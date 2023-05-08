#!/usr/bin/env python3

"""Set the customer ID for the CrowdStrike Falcon sensor.

This file is a template.  It must be processed by Terraform.
"""

from __future__ import annotations

# Standard Python Libraries
# Bandit triggers B404 here, but we're only using subprocess.run() and
# doing so safely.  For more details on B404 see here:
# https://bandit.readthedocs.io/en/latest/blacklists/blacklist_imports.html#b404-import-subprocess
import subprocess  # nosec
import sys
from typing import Any

# Third-Party Libraries
import boto3

# Inputs from Terraform
FALCON_SENSOR_INSTALL_PATH: str = "${falcon_sensor_install_path}"
FALCON_CUSTOMER_ID_KEY: str = "${falcon_customer_id_key}"
SSM_READ_ROLE_ARN: str = "${ssm_read_role_arn}"
SSM_REGION: str = "${ssm_region}"


def get_parameter(ssm_client, parameter_name: str, with_decryption: bool = True) -> str:
    """Get the value of the specified parameter."""
    response: dict[str, Any] = ssm_client.get_parameter(
        Name=parameter_name,
        WithDecryption=with_decryption,
    )
    return response["Parameter"]["Value"]


def main() -> int:
    """Retrieve necessary values from SSM Parameter Store and set the customer ID."""
    # Create STS client
    sts_client = boto3.client("sts")

    # Assume the role that can read the SSM Parameter Store parameters
    stsresponse: dict[str, Any] = sts_client.assume_role(
        RoleArn=SSM_READ_ROLE_ARN,
        RoleSessionName="set_crowdstrike_falcon_sensor_customer_id",
    )
    newsession_id = stsresponse["Credentials"]["AccessKeyId"]
    newsession_key = stsresponse["Credentials"]["SecretAccessKey"]
    newsession_token = stsresponse["Credentials"]["SessionToken"]

    # Create a new client to access SSM Parameter Store using the
    # temporary credentials
    ssm_client = boto3.client(
        "ssm",
        aws_access_key_id=newsession_id,
        aws_secret_access_key=newsession_key,
        aws_session_token=newsession_token,
        region_name=SSM_REGION,
    )

    # Get the values of the SSM Parameter Store parameters
    customer_id: str = get_parameter(ssm_client, FALCON_CUSTOMER_ID_KEY)

    #
    # Set the customer ID
    #
    customer_id_cmd: list[str] = [
        f"{FALCON_SENSOR_INSTALL_PATH}/falconctl",
        "-s",
        f"--cid={customer_id}",
    ]
    # Bandit triggers B603 here, but we're using subprocess.run()
    # safely here, since the variable content in customer_id__cmd
    # comes directly from SSM Parameter Store.  For more details on
    # B603 see here:
    # https://bandit.readthedocs.io/en/latest/plugins/b603_subprocess_without_shell_equals_true.html
    cid_cp: subprocess.CompletedProcess = subprocess.run(customer_id_cmd)  # nosec
    if cid_cp.returncode != 0:
        return cid_cp.returncode

    #
    # Restart the Falcon sensor
    #
    restart_cmd: list[str] = [
        "/usr/bin/systemctl",
        "restart",
        "falcon-sensor.service",
    ]
    # Bandit triggers B603 here, but we're using subprocess.run()
    # safely here, since the variable content in restart_cmd comes
    # directly from SSM Parameter Store.  For more details on B603 see
    # here:
    # https://bandit.readthedocs.io/en/latest/plugins/b603_subprocess_without_shell_equals_true.html
    restart_cp: subprocess.CompletedProcess = subprocess.run(restart_cmd)  # nosec
    return restart_cp.returncode


if __name__ == "__main__":
    sys.exit(main())
