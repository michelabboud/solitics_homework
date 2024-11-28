resource "aws_key_pair" "key-1" {
  provider   = aws.eu-central-1
  key_name   = "pvtlnk"
  public_key = file("keys/ec2-pvlnk.pub")
}

resource "aws_security_group" "pvtlnk-sg-1" {
  provider    = aws.eu-central-1
  vpc_id      = module.vpc_1.vpc_id
  name_prefix = "pvtlnk-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [module.vpc_1]
}

resource "aws_instance" "vpc_1_ec2" {
  provider = aws.eu-central-1

  ami                = data.aws_ami.ubuntu_2204_eu_central-1.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.key-1.key_name
  security_group_ids = aws_security_group.pvtlnk-sg-1.id]
  subnet_id          = module.vpc_1.public_subnets[0]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt -y upgrade
            EOF

  tags = merge(var.tags, { "Name" = "pvtlnl_instance_1" })
}

resource "aws_key_pair" "key-2" {
  provider   = aws.eu-west-3
  key_name   = "pvtlnk"
  public_key = file("keys/ec2-pvlnk.pub")
}

resource "aws_security_group" "pvtlnk-sg-2" {
  provider    = aws.eu-west-3
  vpc_id      = module.vpc_2.vpc_id
  name_prefix = "pvtlnk-sg-"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [module.vpc_2]
}

resource "aws_instance" "vpc_2_ec2" {
  provider = aws.eu-west-3

  ami                = data.aws_ami.ubuntu_2204_eu_west_3.id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.key-2.key_name
  security_group_ids = [aws_security_group.pvtlnk-sg-2.id]
  subnet_id          = module.vpc_2.public_subnets[0]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt -y upgrade
            EOF

  tags = merge(var.tags, { "Name" = "pvtlnl_instance_2" })
}