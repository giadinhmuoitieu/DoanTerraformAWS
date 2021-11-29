provider "aws" {
    region = "us-east-2"
    access_key = "AKIASADPBARDP74YROW7"
    secret_key = "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"
  
}

resource "aws_instance" "server-first" {
    ami = "ami-020db2c14939a8efb"
    instance_type = "t2.micro"
    tags = {
        Name = "Doancuoicung"
    }
}