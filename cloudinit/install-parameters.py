#!/usr/bin/env python3

"""Install TLS Encryption key from SSM Parameter.

This file is a template.  It should be processed by Terraform.
"""

import boto3

# Inputs from terraform
SSM_DH4096_PEM = "${ssm_dh4096_pem}"
SSM_READ_ROLE_ARN = "${ssm_read_role_arn}"
SSM_REGION = "${ssm_region}"
SSM_TLSCRYPT_KEY = "${ssm_tlscrypt_key}"

# These parameters will be copied from SSM and installed in the
# specified location.
INSTALLATION_MAP = {
    SSM_TLSCRYPT_KEY: "/etc/openvpn/server/tlscrypt.key",
    SSM_DH4096_PEM: "/etc/openvpn/server/dh4096.pem",
}

# Create STS client
sts = boto3.client("sts")

# Assume the role that can read the parameters
stsresponse = sts.assume_role(
    RoleArn=SSM_READ_ROLE_ARN, RoleSessionName="openvpn_parameters_install"
)
newsession_id = stsresponse["Credentials"]["AccessKeyId"]
newsession_key = stsresponse["Credentials"]["SecretAccessKey"]
newsession_token = stsresponse["Credentials"]["SessionToken"]

# Create a new client to access SSM using the temporary credentials
ssm = boto3.client(
    "ssm",
    region_name=SSM_REGION,
    aws_access_key_id=newsession_id,
    aws_secret_access_key=newsession_key,
    aws_session_token=newsession_token,
)

# Copy each parameter from SSM and write to the local file system
for src, dst in INSTALLATION_MAP.items():
    parameter = ssm.get_parameter(Name=src, WithDecryption=True)
    with open(dst, "wb") as f:
        f.write(parameter["Parameter"]["Value"].encode("utf-8"))
