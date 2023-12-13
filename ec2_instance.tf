resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  //count         = var.stop_instance ? 0 : 1

  tags = {
    Name = var.instance_name
  }
}
