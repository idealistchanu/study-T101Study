resource "aws_lb" "mynlb" {
  name               = "t101-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id]
  #security_groups    = [aws_security_group.mysg.id]

  tags = {
    Environment = "test"
  }
}

resource "aws_lb_target_group" "mynlbtg" {
  name     = "t101-nlb-tg"
  port     = 443
  protocol = "TLS"
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path                = "/"
    protocol            = "HTTPS"
    matcher             = "200-299"
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "myhttps" {
  load_balancer_arn = aws_lb.mynlb.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn   = "arn:aws:acm:ap-northeast-2:310600283911:certificate/90b32e4b-fd19-440a-b9d2-e02e3b3e9ab9"
  alpn_policy       = "HTTP2Preferred"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mynlbtg.arn
  }
}


# resource "aws_lb_listener_rule" "mynlbrule" {
#   listener_arn = aws_lb_listener.myhttps.arn
#   priority     = 100

#   condition {
#     path_pattern {
#       values = ["*"]
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.mynlbtg.arn
#   }
# }

output "mynlb_dns" {
  value       = aws_lb.mynlb.dns_name
  description = "The DNS Address of the NLB"
}
