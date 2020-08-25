#======
# ALB
#======
resource "aws_lb" "alb" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  security_groups    = [var.sg_alb_id]
  subnets            = [var.subnet_public_1a_id, var.subnet_public_1c_id]
}

#===============
# Target Group
#===============
// Blue
resource "aws_lb_target_group" "alb_target_group_blue" {
  name        = "${var.app_name}-target-group-blue"
  port        = var.port_http // ALBからのルーティング時解放ポート
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  // ヘルスチェック
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 10
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.alb]
}

// Green
resource "aws_lb_target_group" "alb_target_group_green" {
  name        = "${var.app_name}-target-group-green"
  port        = var.port_http // ALBからのルーティング時解放ポート
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  // ヘルスチェック
  health_check {
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 300
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.alb]
}

#===========
# Listener
#===========
// HTTP -> HTTPS リダイレクト 
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port_http
  protocol          = "HTTP"

  // アクション
  default_action {
    type = "redirect"

    // リダイレクト先
    redirect {
      port        = var.port_https
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

}

// Blue環境
resource "aws_lb_listener" "lb_listener_blue" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port_https // ALBの受信時の解放ポート
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  // アクション
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_blue.arn
  }

  // Blue/Greenデプロイメントによるターゲットグループの動的差分を無視
  // NOTE: apply時にコメントアウトする
  lifecycle {
    ignore_changes = [default_action]
  }
}

// Green環境
resource "aws_lb_listener" "lb_listener_green" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.port_custom_tcp_https // ALBの受信時の解放ポート
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  // アクション
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group_green.arn
  }
}