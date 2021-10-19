resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

resource "local_file" "pem_file" {
  filename = pathexpand("./${var.key_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  sensitive_content = tls_private_key.ssh.private_key_pem
}

resource "aws_security_group" "default-sg" {
  name        = "default-sg"
  description = "Security group default"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
   ingress {
    from_port   = 8000
    to_port     = 8000 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    from_port   = 8080
    to_port     = 8080 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


   egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "default-sg"
  }

}

resource "aws_instance" "instance" {
  count         = "${var.instance_count}"	 
  ami           = "ami-02e136e904f3da870"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.generated_key.key_name
  
  vpc_security_group_ids = [
    "${aws_security_group.default-sg.id}"
  ]

  tags = {
    Name = element(var.instance_tags, count.index) 
  }

  provisioner "remote-exec" {
    inline = ["sudo yum update -y", 
              "sudo yum install python3 -y",
              "sudo yum-config-manager --enable extras",
	      "sudo amazon-linux-extras install docker -y",
              "sudo service docker start"]

    connection {
      host        = "${self.public_ip}" 
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("./${var.key_name}.pem")
    }
  }

}

resource "local_file" "ip" {
  filename = "ip_inventory"
  content = <<-EOT
  [${element(var.instance_tags, 0)}]
  ${aws_instance.instance[0].public_ip}
  [${element(var.instance_tags, 1)}]
  ${aws_instance.instance[1].public_ip}
  EOT
  }

