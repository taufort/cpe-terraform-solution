resource "aws_security_group" "ssh" {
  name        = "${var.project}-ssh-access"
  description = "SSH access"
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
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_key_pair" "bastion" {
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCweMKj8IAoOlVBBj//RWM1hV+qexfVq2JesIrjWFDXLAG7FJyk97b/ifTfOHtvo/40ARWL1HtkNW8sahkjKNaB6Jpks/ny/apfOAw6AYzkvi1mweLm7T0Q2Qz3NJ75GU0qAt88PiATIdBF3MoIVSixXNXAJ4JKCWGvX2WBnOSxE5z5bc7hgCw27SjrxlSdCYmPfomH68U0URDxYW/Q4+38jsWwyhTHxfPfuXxrauEg3i63eHs+vOpild5sP48Pt4blpw9KRfEn3+8/S8MOBHa6emfzgGTuyZTuaqmbuaVLlrZuMILc+caoVJH0xMOWrqttli8bdIk2s+HwmJsztiIAoNXzlrrLi5dINJnZBDnyAx0H3ylscmssbR+8WQ0dxwXhZ9py+iKlzREMwKO0+CvFVnvOTODJQo60huKZeYqcHabJiDSFQ6/y7XqJT2Vqy1J/2U1GVPQ+VSG/niETnNxNfAJpp8hLRLQTf4DShAr/DC+WlRlASPuIXoOS0cwNLoM= taufort@taufort-XPS-15-7590"
}

resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.amazon_linux_2_ami.id
  instance_type        = "t3.small"
  iam_instance_profile = data.aws_iam_instance_profile.ssm_instance_profile.name
  subnet_id            = aws_subnet.public_a.id
  key_name             = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [
    aws_security_group.ssh.id,
  ]

  tags = {
    Name = "${var.project}-bastion"
  }
}
