resource "aws_security_group" "sg" {
  name        = "sg_${var.ENV}_${var.COMPONENT}"
  description = "sg_${var.ENV}_${var.COMPONENT}"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID


  ingress {
    description      = "APP"
    from_port        = var.APP_PORT
    to_port          = var.APP_PORT
    protocol         = "tcp"
    cidr_blocks      = var.APP_PORT == 80 ? data.terraform_remote_state.vpc.outputs.VPC_CIDR : data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_CIDR
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = concat(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_CIDR, tolist([data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]))
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  tags = {
    Name = "sg_${var.ENV}_${var.COMPONENT}"
  }
}

