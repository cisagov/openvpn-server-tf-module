#!/usr/bin/env python3

"""Set parameters for the Qualys Cloud Agent.

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
QUALYS_ACTIVATION_ID_KEY: str = "${qualys_activation_id_key}"
QUALYS_CUSTOMER_ID_KEY: str = "${qualys_customer_id_key}"
QUALYS_FEDRAMP: str = "${qualys_fedramp}"
QUALYS_INSTALL_PATH: str = "${qualys_install_path}"
QUALYS_SERVER_URI_KEY: str = "${qualys_server_uri_key}"
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
    """Retrieve necessary values from SSM Parameter Store and set the parameters."""
    # Create STS client
    sts_client = boto3.client("sts")

    # Assume the role that can read the SSM Parameter Store parameters
    stsresponse: dict[str, Any] = sts_client.assume_role(
        RoleArn=SSM_READ_ROLE_ARN,
        RoleSessionName="set_crowdstrike_falcon_sensor_customer_id",
    )
    newsession_id: str = stsresponse["Credentials"]["AccessKeyId"]
    newsession_key: str = stsresponse["Credentials"]["SecretAccessKey"]
    newsession_token: str = stsresponse["Credentials"]["SessionToken"]

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
    activation_id: str = get_parameter(ssm_client, QUALYS_ACTIVATION_ID_KEY)
    customer_id: str = get_parameter(ssm_client, QUALYS_CUSTOMER_ID_KEY)
    server_uri: str = get_parameter(ssm_client, QUALYS_SERVER_URI_KEY)

    # Set the activation ID, customer ID, server URI, and FEDRAMP
    # setting.
    cmd: list[str] = [
        f"{QUALYS_INSTALL_PATH}/bin/qualys-cloud-agent.sh",
        f"ActivationId={activation_id}",
        f"CustomerId={customer_id}",
        f"FEDRAMP={QUALYS_FEDRAMP}",
        f"ServerUri={server_uri}",
    ]
    # Bandit triggers B603 here, but we're using subprocess.run()
    # safely since the variable content in cmd comes directly from SSM
    # Parameter Store.  For more details on B603 see here:
    # https://bandit.readthedocs.io/en/latest/plugins/b603_subprocess_without_shell_equals_true.html
    cid_cp: subprocess.CompletedProcess = subprocess.run(cmd)  # nosec B603
    return cid_cp.returncode


if __name__ == "__main__":
    sys.exit(main())
