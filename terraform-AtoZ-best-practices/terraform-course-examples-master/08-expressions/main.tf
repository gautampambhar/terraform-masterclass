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

data "aws_vpc" "main" {
	default = true
}

locals {
	baz = "hello"
}

variable "testing" {
	type = map
	default = {
		foo = 123
		bar = 555
	}
}

/*
resource "aws_instance" "web" {
	count         = 2
	ami           = "ami-003634241a8fcdec0"
	instance_type = "t2.micro"

	tags = {
		Name = "Tuts Test ${count.index}"
	}
}
*/

output "foo" {
	# lists out an list/array of instance ids
	#value = aws_instance.web[*].id
	#value = [for instance in aws_instance.web : instance.public_ip] # return all instance's public IP
	#value = [for k, v in var.testing : upper(k)] # return all key with upper case
	value = [for k, v in var.testing : k if k == "foo"] # return key if key = foo // this will return foo
}

resource "aws_instance" "tuts" {
	ami           = "ami-003634241a8fcdec0"
	instance_type = "t2.micro"

	tags = {
		Name = "Tuts Test ${local.baz}"
		foo  = local.baz == "aaa" ? "yes" : "no" # if local.baz == "aaa" then value is "yes". if not then set it to "no"
		
		# Multi line string
		bar  = <<EOT
			testing foo
		EOT
		baz  = <<-EOT
			hello from baz, no indentation with the "-"
		EOT
	}
}
