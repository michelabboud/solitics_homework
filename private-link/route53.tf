
resource "aws_route53_zone" "private_zone" {

  provider = aws.eu-central-1

  name = "michel.internal"  # Change to your domain name
  vpc {
    vpc_id = module.vpc_1.vpc_id
  }
  comment = "Private hosted zone for internal use"
}

resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "instance-1.michel.internal"
  type    = "A"
  ttl     = 300
  records = [aws_instance.vpc_1_ec2.public_ip]

  depends_on = [aws_instance.vpc_1_ec2]
}

resource "aws_route53_record" "nlb_alias" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "nlb.michel.internal"
  type    = "A"

  alias {
    name                   = aws_lb.nlb.dns_name
    zone_id                = aws_lb.nlb.zone_id
    evaluate_target_health = true
  }
}

