# The EIP for the public IP address of the OpenVPN server
#
# Note that the internet gateway has already been created in
# cool-sharedservices-networking, so the is no need for a depends_on
# for the IGW here.
resource "aws_eip" openvpn {
  instance = aws_instance.openvpn.id
  tags     = var.tags
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

  user_data_base64 = data.template_cloudinit_config.cloud_init_tasks.rendered

  tags                 = var.tags
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
}
