###########################################
## Random String Generator
###########################################

resource "random_string" "myrand_string" {
  #count   = 2
  length  = 5
  upper   = false
  special = false
}

###########################################
## AWS EC2 Instance  
###########################################

resource "aws_instance" "this" {
  #count         = 2
  ami           = var.ami_value  // Replace this with the appropriate AMI ID for Debian
  instance_type = var.aws_instance_type       // Choose the appropriate instance type
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  associate_public_ip_address = true
  key_name = var.key_name
  tags = {
    #Name = "${var.instance_name}-${random_string.myrand_string[count.index].result}"
    Name = "${var.instance_name}-${random_string.myrand_string.result}"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.this.id
  # domain   = "vpc"
}

resource "aws_eip_association" "name" {
  network_interface_id = aws_instance.this.primary_network_interface_id
  allocation_id = aws_eip.lb.id
}

locals {
  instance_id = aws_instance.this.id
}

resource "aws_security_group" "instance_sg" {
  name        = "instance-security-group"
  description = "Security group for EC2 instance allowing SSH access"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################################
## Creating CloudWatch Alarm for CPU Utilization
############################################################

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  #count               = length(aws_instance.this[*].id)  // Count based on the number of instances created
  alarm_name          = "CPUUtilizationGreaterThan30Percent"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Maximum"
  threshold           = 30

  dimensions = {
    #InstanceId = aws_instance.this[count.index].id
    InstanceId = aws_instance.this.id
  }

  alarm_description = "Alarm when CPU exceeds 30%"

  alarm_actions = [aws_sns_topic.notification_topic.arn]

  treat_missing_data = "notBreaching"
}

#############################################
## Notification Topic
#############################################

resource "aws_sns_topic" "notification_topic" {
  name = "Tier1SupportEmailTopic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

#############################################
## CloudWatch Dashboard (Declare this resource)
#############################################
resource "aws_cloudwatch_dashboard" "name" {
  dashboard_name = "MyCloudWatchDashboard"
  dashboard_body = data.template_file.dashboard_config.rendered
}

data "template_file" "dashboard_config" {
  template = file("${path.module}/dashboard.json")

  vars = {
    instance_id = local.instance_id
    region = var.region
  }
}


/*data "template_file" "dashboard_file" {
  template = file("${path.module}/dashboard.json")
  
  vars = {
  instance_ids = jsonencode([for instance in aws_instance.this : instance.instance_ids])
}
*/