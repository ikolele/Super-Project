variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"   # ✅ your Jenkins is in us-east-1
}

variable "aws_type" {
  description = "AWS EC2 instance type"
  default     = "t3.medium"
}

variable "aws_ami" {
  description = "AWS AMI for Amazon Linux 2 (x86_64)"
  default     = "ami-0c02fb55956c7d316"   # ✅ latest Amazon Linux 2 for us-east-1
}
