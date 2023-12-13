variable "aws_region" {
  description = "AWS Region"
}

variable "ami_id" {
  description = "AMI ID"
}

variable "instance_name" {
  description = "Instance Name Tag"
}

variable "stop_instance" {
  description = "Stop EC2 Instance"
  default     = false
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  count         = var.stop_instance ? 0 : 1

  tags = {
    Name = var.instance_name
  }
}

output "instance_id" {
  value = aws_instance.example.id
}
