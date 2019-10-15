# The openvpn EC2 instance
resource "aws_instance" "openvpn" {
  ami                         = data.aws_ami.openvpn.id
  ebs_optimized               = true
  instance_type               = var.aws_instance_type
  availability_zone           = data.aws_subnet.the_subnet.availability_zone
  subnet_id                   = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids = concat([
    aws_security_group.openvpn_servers.id,
  ], var.security_groups)

  user_data_base64 = data.template_cloudinit_config.cloud_init_tasks.rendered

  tags                 = var.tags
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name
}
