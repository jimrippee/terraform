provider "aws" {
    region = "us-west-1"
  
}
resource "aws_instance" "example" {
    ami = "ami-0d382e80be7ffdae5"
    instance_type = "t2.nano"

    tags = {
      "Name" = "terraform-example"
    }   
  
}

