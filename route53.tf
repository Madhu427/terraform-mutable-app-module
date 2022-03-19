resource "aws_route53_record" "private-record" {
  count = var.LB_PRIVATE ? 1 :0
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.example.com"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.lb.public_ip]
}