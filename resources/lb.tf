resource "aws_elb" "TF-LB" {
  name    = "TF-LB"
  subnets = [aws_subnet.AZ-A.id, aws_subnet.AZ-B.id, aws_subnet.AZ-C.id]
  security_groups = [aws_security_group.LbNSG.id]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.AC-A.id, aws_instance.AC-B.id, aws_instance.AC-C.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "TF-LB"
  }
}

