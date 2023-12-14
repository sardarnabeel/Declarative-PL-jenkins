//use it when conditionally create ec2 instance
# output "instance_id" {
#   value = aws_instance.example[0].id
# }


output "instance_id" {
  value = aws_instance.example.id
}