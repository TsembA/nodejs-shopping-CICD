# ====================================
# CPU Utilization Alarm
# ====================================
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "nodejs-shopping-cpu-high"
  alarm_description   = "CPU usage is too high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"
}
# ====================================
# EC2 System Status Check Alarm
# ====================================
resource "aws_cloudwatch_metric_alarm" "system_check_failed" {
  alarm_name          = "nodejs-shopping-system-check-failed"
  alarm_description   = "EC2 system status check failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"
}
# ====================================
# EC2 Instance Status Check Alarm
# ====================================
resource "aws_cloudwatch_metric_alarm" "instance_check_failed" {
  alarm_name          = "nodejs-shopping-instance-check-failed"
  alarm_description   = "EC2 instance is unreachable"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "StatusCheckFailed_Instance"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0

  dimensions = {
    InstanceId = aws_instance.app.id
  }

  treat_missing_data = "notBreaching"
}
