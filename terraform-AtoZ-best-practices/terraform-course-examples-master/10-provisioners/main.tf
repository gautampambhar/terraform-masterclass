terraform {
	required_providers {
		aws = {
			source  = "hashicorp/aws"
			version = "~> 3.74"
		}
	}
}

provider "aws" {
	region = "us-west-2"
}

resource "aws_instance" "web" {
	ami           = "ami-003634241a8fcdec0"
	instance_type = "t2.micro"
	key_name      = "william"

	tags = {
		Name = "Tuts test"
	}

	# Allow you to login to the server and upload the content of the file you want to upload
	connection {
		type        = "ssh"
		host        = self.public_ip
		user        = "ubuntu"
		private_key = file("/home/focus/Downloads/william.pem")
		# Default timeout is 5 minutes
		timeout     = "4m"
	}

	# Upload file on a remote server
	provisioner "file" {
		content     = "Hello there"
		destination = "/home/ubuntu/tuts.txt"
	}

	# This will create a file on the machine you're executing terraform command
	provisioner "local-exec" {
		command = "echo ${self.public_ip} > instance-ip.txt"
	}

	# allows to run a script on remote machine(can be any machine; if remote then define connection section of that machine)
	provisioner "remote-exec" {
		#script = "" # to run script. 
		inline = [
			"touch /home/ubuntu/tuts-remote-exec.txt"
		]
	}
}
