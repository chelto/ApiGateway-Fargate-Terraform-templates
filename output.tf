output "privatesubnets" {
  value = tolist(data.aws_subnet_ids.private.ids)
}

output "vpcid" {
  value = data.aws_vpc.selected.id
}

output "security_group_ids" {
  value = aws_security_group.sidecar_security_group.id
}


output "private_route_tables" {
  value = [for s in data.aws_route_table.selected : s.id]
}

output "ECR_repo_url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "service_discovery_arn" {
  value = aws_service_discovery_service.service_discovery.arn
}

