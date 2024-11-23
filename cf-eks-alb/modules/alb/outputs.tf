output "alb_dns" {
  value = module.alb.this_lb_dns_name
}

output "alb_sg_id" {
  value = var.alb_sg_id
}