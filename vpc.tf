# A data source for the VPC in which the specified subnet lives
data "aws_vpc" "the_vpc" {
  provider = aws.ec2
  id       = data.aws_subnet.the_subnet.vpc_id
}
