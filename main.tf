provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "nginx_instances" {
  count         = 2
  ami           = "ami-0097e4945b2d15c30"
  instance_type = "t2.micro"
  key_name = "wsl"

  tags = {
    Name = "NginxInstance-${count.index + 1}"
  }
}

output "instance_ips" {
  value = aws_instance.nginx_instances[*].public_ip
}

resource "local_file" "inventory" {
  content = <<EOT
[nodes]
${join("\n", aws_instance.nginx_instances[*].public_ip)}

EOT

  filename = "${path.module}/inventory.ini"
}
