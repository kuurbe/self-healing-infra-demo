# ---------------------
# EC2 Instance
# ---------------------
resource "aws_instance" "monitored" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "SelfHealingEC2"
  }
}

# ---------------------
# CloudWatch Log Group
# ---------------------
resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/ec2/self-healing"
  retention_in_days = 7
}

# ---------------------
# IAM Role for Lambda
# ---------------------
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_ec2_reboot_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_ec2_reboot_policy"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["ec2:RebootInstances"],
      Resource = "*"
    }]
  })
}

# ---------------------
# Lambda Function
# ---------------------
resource "aws_lambda_function" "reboot_ec2" {
  function_name = "reboot_ec2_lambda"
  runtime       = "python3.9"
  handler       = "reboot-ec2.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn

  filename         = "${path.module}/../remediation/lambda-functions/lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/../remediation/lambda-functions/lambda.zip")
}

# ---------------------
# CloudWatch Alarm
# ---------------------
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Triggers if CPU > 80% for 5 minutes"

  dimensions = {
    InstanceId = aws_instance.monitored.id
  }

  alarm_actions = [aws_lambda_function.reboot_ec2.arn]
}