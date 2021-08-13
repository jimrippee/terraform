variable "server_port" {
  description = "The port used for HTTP"
  type = number
  default = 8080
  
}

variable "ssh_port"{
  description = "Open up SSH on the web server"
  type = number
  default = 22
  
}

provider "aws" {
    region = "us-west-1"
  
}
resource "aws_instance" "example" {
    ami                     = "ami-0d382e80be7ffdae5"
    instance_type           = "t2.nano"
    vpc_security_group_ids  = [aws_security_group.instance.id]

    user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World. Love you Nina." > index.html
                nohup busybox httpd -f -p ${var.server_port} &
                EOF


    tags = {
      "Name" = "terraform-example"
    }
}
resource "aws_security_group" "instance" {
  name = "teraform-example-instance"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = var.ssh_port
    to_port   = var.ssh_port
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "public_ip" {
  value         = aws_instance.example.public_ip
  description   = "The public IP address of the web server"
}
