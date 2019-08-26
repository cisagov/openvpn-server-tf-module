# A data source for the subnet specified
data "aws_subnet" "the_subnet" {
  id = var.subnet_id
}

data "aws_availability_zone" "the_az" {
  name = data.aws_subnet.the_subnet.availability_zone
}
