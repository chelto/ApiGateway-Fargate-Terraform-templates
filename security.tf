resource "aws_security_group" "sidecar_security_group" {
  name        = "${var.name_prefix}-sg"
  description = "${var.name_prefix} security group"
  vpc_id      = var.vpc_id
  tags        = var.default_tags
  # might need to refine down/////
  ingress {
    from_port        = var.controller_port
    to_port          = var.controller_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "VPC_endpoint_sg" {
  name        = "${var.name_prefix}-VPC_endpoin-sg"
  description = "${var.name_prefix} security group"
  vpc_id      = var.vpc_id
  tags        = var.default_tags
  # might need to refine down/////
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}