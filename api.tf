

module "api_gateway" {
  source                      = "terraform-aws-modules/apigateway-v2/aws"
  name                        = "${var.name_prefix}-api"
  description                 = "HTTP API Gateway"
  protocol_type               = "HTTP"
  domain_name                 = "${var.route53_subdomain}.${var.domain_name}"
  domain_name_certificate_arn = var.domain_name_certificate_arn

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }
  create_vpc_link              = true
  disable_execute_api_endpoint = true

  vpc_link_tags = merge(
    var.default_tags,
    {
      Name = "${var.name_prefix}-VPC-Link"
    }
  )
  vpc_links = {
    my-vpc = {
      name               = "${var.name_prefix}-sidecar-vpc-link1"
      security_group_ids = [aws_security_group.VPC_endpoint_sg.id]
      subnet_ids         = tolist(data.aws_subnet_ids.private.ids)
    }
  }
  # Routes and integrations
  integrations = {
    "GET /metrics" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "my-vpc"
      integration_uri    = aws_service_discovery_service.service_discovery.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    },
    "GET /health" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "my-vpc"
      integration_uri    = aws_service_discovery_service.service_discovery.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    },
    "GET /metrics/prometheus" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "my-vpc"
      integration_uri    = aws_service_discovery_service.service_discovery.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    },
    "GET /v2/map" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "my-vpc"
      integration_uri    = aws_service_discovery_service.service_discovery.arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    }
  }

  tags = merge(
    var.default_tags,
    {
      Name = "${var.name_prefix}-api"
    }
  )
}