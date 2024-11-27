output "eu-west-3-ami-id"  {
  value = data.aws_ami.ubuntu_2204_eu_west_3.id
}

output "eu-west-1-ami_image_location" {
  value = data.aws_ami.ubuntu_2204_eu_west_3.image_location
}

output "eu-central-1-ami_id" {
  value = data.aws_ami.ubuntu_2204_eu_central-1.id
}

output "eu-central-1-ami_image_location" {
  value = data.aws_ami.ubuntu_2204_eu_central-1.image_location
}

output "vpc_1_ec2_public_ip" {
  value = aws_instance.vpc_1_ec2.public_ip
}

output "vpc_2_ec2_public_ip" {
  value = aws_instance.vpc_2_ec2.public_ip
}
