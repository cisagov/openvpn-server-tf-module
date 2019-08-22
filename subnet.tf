# A data source for the subnet specified
data "aws_subnet" "the_subnet" {
  provider = aws.ec2
  id       = var.subnet_id
}

data "aws_availability_zone" "the_az" {
  provider = aws.ec2
  name     = data.aws_subnet.the_subnet.availability_zone
}
