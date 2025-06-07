variable "aws_region" {
  default = "eu-north-1"
}

variable "ami_id" {
  default = "ami-006b4a3ad5f56fbd6" # Amazon Linux 2 у eu-north-1
}

variable "instance_type" {
  default = "t3.micro"
}

variable "teams_webhook_url" {
  type = string
  description = "Microsoft Teams terraform webhook URL"
}
