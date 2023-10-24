#!/usr/bin/env python3

"""Link Nessus Agent to Tenable/Nessus server.

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
NESSUS_AGENT_INSTALL_PATH: str = "${nessus_agent_install_path}"
NESSUS_GROUPS: str = "${nessus_groups}"
NESSUS_HOSTNAME_KEY: str = "${nessus_hostname_key}"
NESSUS_KEY_KEY: str = "${nessus_key_key}"
NESSUS_PORT_KEY: str = "${nessus_port_key}"
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
    """Retrieve necessary values from SSM Parameter Store and link the Nessus Agent."""
    # Create STS client
    sts_client = boto3.client("sts")

    # Assume the role that can read the SSM Parameter Store parameters
    stsresponse: dict[str, Any] = sts_client.assume_role(
        RoleArn=SSM_READ_ROLE_ARN, RoleSessionName="nessus_agent_linking"
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
    nessus_hostname: str = get_parameter(ssm_client, NESSUS_HOSTNAME_KEY)
    nessus_key: str = get_parameter(ssm_client, NESSUS_KEY_KEY)
    nessus_port: str = get_parameter(ssm_client, NESSUS_PORT_KEY)

    # Link the Nessus Agent
    link_cmd: list[str] = [
        f"{NESSUS_AGENT_INSTALL_PATH}/sbin/nessuscli",
        "agent",
        "link",
        f"--key={nessus_key}",
        f"--host={nessus_hostname}",
        f"--port={nessus_port}",
        f"--groups={NESSUS_GROUPS}",
    ]
    # Bandit triggers B603 here, but we're using subprocess.run()
    # safely here, since the variable content in link_cmd comes
    # directly from SSM Parameter Store.  For more details on B603 see
    # here:
    # https://bandit.readthedocs.io/en/latest/plugins/b603_subprocess_without_shell_equals_true.html
    cp: subprocess.CompletedProcess = subprocess.run(link_cmd)  # nosec
    return cp.returncode


if __name__ == "__main__":
    sys.exit(main())
