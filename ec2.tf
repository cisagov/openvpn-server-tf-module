# The EIP for the public IP address of the OpenVPN server
#
# Note that the internet gateway has already been created in
# cool-sharedservices-networking, so the is no need for a depends_on
# for the IGW here.
resource "aws_eip" "openvpn" {
  instance = aws_instance.openvpn.id
  vpc      = true
}

# The openvpn EC2 instance
resource "aws_instance" "openvpn" {
  ami                         = data.aws_ami.openvpn.id
  associate_public_ip_address = true
  ebs_optimized               = true
  instance_type               = var.aws_instance_type
  availability_zone           = data.aws_subnet.the_subnet.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids = concat([
    aws_security_group.openvpn_servers.id,
  ], var.security_groups)
  user_data_base64 = data.cloudinit_config.cloud_init_tasks.rendered
  # AWS Instance Meta-Data Service (IMDS) options
  metadata_options {
    # Enable IMDS (this is the default value)
    http_endpoint = "enabled"
    # Restrict put responses from IMDS to a single hop (this is the
    # default value).  This effectively disallows the retrieval of an
    # IMDSv2 token via this machine from anywhere else.
    http_put_response_hop_limit = 1
    # Require IMDS tokens AKA require the use of IMDSv2
    http_tokens = "required"
  }
  root_block_device {
    volume_size = var.root_disk_size
    volume_type = "gp3"
  }
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
}
