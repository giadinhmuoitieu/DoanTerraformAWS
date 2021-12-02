resource "aws_instance" "server-first" {
    ami = "ami-020db2c14939a8efb"
    instance_type="t2.micro"    
    availability_zone = "us-east-2a"
    tags = {
        Name = "Doancuoicung1"
    }
    key_name = "KeyDoan"
    network_interface {
            device_index = 0
            network_interface_id = aws_network_interface.nic.id

    }
    user_data = <<EOF
        #! /bin/bash
#! /bin/bash
                sudo apt-get update
		sudo apt-get install -y apache2
		sudo systemctl start apache2
		sudo systemctl enable apache2
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
    EOF
}