resource "aws_key_pair" "key-1" {
  provider   = aws.eu-central-1
  key_name   = "pvtlnk"
  public_key = file("keys/ec2-pvlnk.pub")
}

resource "aws_security_group" "pvtlnk-sg-1" {
  provider    = aws.eu-central-1
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
}

resource "aws_instance" "vpc_1_ec2" {
  provider = aws.eu-central-1

  ami             = eu-central-1-ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.key-1.key_name
  security_groups = [aws_security_group.pvtlnk-sg-1.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
            EOF

  tags = var.tags
}

resource "aws_key_pair" "key-2" {
  provider   = aws.eu-west-3
  key_name   = "pvtlnk"
  public_key = file("keys/ec2-pvlnk.pub")
}

resource "aws_security_group" "pvtlnk-sg-2" {
  provider    = aws.eu-west-3
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
}

resource "aws_instance" "vpc_2_ec2" {
  provider = aws.eu-central-1

  ami             = eu-west-3-ami_id
  instance_type   = var.instance_type
  key_name        = aws_key_pair.key-2.key_name
  security_groups = [aws_security_group.pvtlnk-sg-2.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update
            EOF

  tags = var.tags
}