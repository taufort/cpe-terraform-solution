resource "aws_security_group" "http" {
  name        = "${var.project}-http-access"
  description = "HTTP access"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = [
      "${aws_instance.bastion.private_ip}/32",
    ]
  }
}

resource "aws_instance" "http_server" {
  ami           = data.aws_ami.amazon_linux_2_ami.id
  instance_type = "t3.small"
  subnet_id     = aws_subnet.private_a.id
  vpc_security_group_ids = [
    aws_security_group.http.id,
  ]
  user_data = data.local_file.user_data.content

  tags = {
    Name = "${var.project}-http-server"
  }
}

data "local_file" "user_data" {
  filename = "${path.module}/cloud_init.sh"
}
