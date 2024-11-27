output "eu-west-3-ami-id"  {
  value = data.aws_ami.ubuntu_2404_eu_west_3.id
}

output "eu-central-1-ami_id" {
  value = data.aws_ami.ubuntu_2404_eu_central-1.id
}
