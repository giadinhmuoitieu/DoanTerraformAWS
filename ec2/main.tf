resource "aws_instance" "webserver" {
    instance_type = var.type
    ami           = var.ami_id
   
    key_name      = var.key_name
    subnet_id = var.subnet_id

    tags = {
      Name = "Apache_Webserver",
    }
    vpc_security_group_ids= var.vpc_security_groups_ids
    # security_groups = ["${aws_security_group.ec2_webserver_security_group.name}"]
    user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello from Webserver at instance id `curl  </h1></body></html>" > /var/www/html/index.html
      EOF
}



resource "aws_instance" "privatewebserver" {
    instance_type = var.type
    ami           = var.ami_id
   
    key_name      = var.key_name
    subnet_id   =    var.private_subnet_id

    tags = {
      Name = "private Webserver"
    }
    vpc_security_group_ids= var.vpc_security_groups_ids
    # security_groups = ["${aws_security_group.ec2_webserver_security_group.name}"]
    user_data = <<-EOF
      #!/bin/sh
      sudo apt-get update
      sudo apt install -y apache2
      sudo systemctl status apache2
      sudo systemctl start apache2
      sudo chown -R $USER:$USER /var/www/html
      sudo echo "<html><body><h1>Hello from Webserver at instance id `curl  </h1></body></html>" > /var/www/html/index.html
      EOF
}