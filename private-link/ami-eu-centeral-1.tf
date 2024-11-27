data "aws_ami" "ubuntu_2204_eu_central-1" {
  provider    = aws.eu-central-1
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon/ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-*"]

  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
