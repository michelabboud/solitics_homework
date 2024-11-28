resource "aws_vpc_endpoint_service" "service_endpoint" {

  provider = aws.eu-central-1

  acceptance_required        = true
  network_load_balancer_arns = [aws_lb.nlb.arn]

  allowed_principals = [
    "arn:aws:iam::${var.account_id}:root"
  ]

  private_dns_name = "service.michel.internal"

  tags       = merge({ "Name" = "service-endpoint" }, var.tags)
  depends_on = [module.vpc_1, module.vpc_2, aws_lb.nlb]
}

resource "aws_vpc_endpoint" "client_endpoint" {

  provider = aws.eu-central-1

  vpc_id             = module.vpc_1.vpc_id
  service_name       = aws_vpc_endpoint_service.service_endpoint.service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = module.vpc_1.public_subnets
  security_group_ids = [aws_security_group.pvtlnk-sg-1.id]

#   private_dns_enabled = true

  tags = merge({ "Name" = "client-endpoint" }, var.tags)

  depends_on = [module.vpc_1, module.vpc_2, aws_lb.nlb]
}

resource "aws_vpc_endpoint_connection_accepter" "endpoint_accept" {
  vpc_endpoint_service_id = aws_vpc_endpoint_service.service_endpoint.id
  vpc_endpoint_id         = aws_vpc_endpoint.client_endpoint.id

  depends_on = [aws_vpc_endpoint.client_endpoint, aws_vpc_endpoint_service.service_endpoint]
}