# s3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = [for s in data.aws_route_table.selected : s.id]
  auto_accept       = true
  vpc_endpoint_type = "Gateway"
  tags = merge(
    var.default_tags,
    {
      Name = "s3-vpc-endpoint"
    }
  )
}

# API Gateway
resource "aws_vpc_endpoint" "apigateway-endpoint" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.execute-api"
  security_group_ids  = [aws_security_group.VPC_endpoint_sg.id]
  subnet_ids          = tolist(data.aws_subnet_ids.private.ids)
  private_dns_enabled = true
  auto_accept         = true
  vpc_endpoint_type   = "Interface"
  tags = merge(
    var.default_tags,
    {
      Name = "apigateway-vpc-endpoint"
    }
  )
}

# ECR
resource "aws_vpc_endpoint" "ecr-endpoint" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  security_group_ids  = [aws_security_group.VPC_endpoint_sg.id]
  subnet_ids          = tolist(data.aws_subnet_ids.private.ids)
  private_dns_enabled = true
  auto_accept         = true
  vpc_endpoint_type   = "Interface"
  tags = merge(
    var.default_tags,
    {
      Name = "ecr-vpc-endpoint"
    }
  )
}

# cloudwatch
resource "aws_vpc_endpoint" "logs-endpoint" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.logs"
  security_group_ids  = [aws_security_group.VPC_endpoint_sg.id]
  subnet_ids          = tolist(data.aws_subnet_ids.private.ids)
  private_dns_enabled = true
  auto_accept         = true
  vpc_endpoint_type   = "Interface"
  tags = merge(
    var.default_tags,
    {
      Name = "cloudwatch-vpc-endpoint"
    }
  )
}

# docker
resource "aws_vpc_endpoint" "docker-endpoint" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  security_group_ids  = [aws_security_group.VPC_endpoint_sg.id]
  subnet_ids          = tolist(data.aws_subnet_ids.private.ids)
  private_dns_enabled = true
  auto_accept         = true
  vpc_endpoint_type   = "Interface"
  tags = merge(
    var.default_tags,
    {
      Name = "docker-ECR-vpc-endpoint"
    }
  )
}
