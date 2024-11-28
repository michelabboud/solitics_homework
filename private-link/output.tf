output "eu-west-3-ami-id"  {
  value = data.aws_ami.ubuntu_2204_eu_west_3.id
}

output "eu-west-3-ami_image_location" {
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

output "vpc_1_id" {
  value = module.vpc_1.vpc_id
}

output "vpc_2_id" {
  value = module.vpc_2.vpc_id
}

output "private_zone_id" {
  value = aws_route53_zone.private_zone.zone_id
}

output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
}

output "nlb_zone_id" {
  value = aws_lb.nlb.zone_id
}