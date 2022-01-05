
// Route 53 & ACM
variable "domain_name" {
  type        = string
  description = "Existing domain record already setup in route53"
  # default     = "something.com"
}

variable "route53_subdomain" {
  type        = string
  description = "subdomain name which API gateway will use for custom domain setup. Needs to match the ACM SSL"
  # default     = "example"
}

variable "domain_name_certificate_arn" {
  type        = string
  description = "The ACM certificate ARN to use for the api gateway"
  # default     = "arn:aws:acm:eu-west-2:accountid:certificate/234234324342"
}



variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "name_prefix" {
  type        = string
  description = "name prefix to give to all recources in project"

}

variable "vpc_id" {
  type        = string
  description = "vpc id with 2 private subnets already existing"
  # default     = "vpc-12345678123213"
}

variable "command_args" {
  type        = list
  description = "docker container command arguments"
  # default     = ["-example", "-example2"]
}


variable "controller_task_role_arn" {
  type        = string
  description = "An custom task role to use for the jenkins controller (optional)"
  default     = null
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "An custom execution role to use as the ecs exection role (optional)"
  default     = null
}

variable "controller_port" {
  type    = number
  default = 5000
}

variable "controller_cpu" {
  type    = number
  default = 2048
}

variable "controller_memory" {
  type    = number
  default = 4096
}

variable "default_tags" {
  default = {
    Terraform = "true"
    Project   = "sidecar"
  }
  description = "Additional resource tags"
  type        = map(string)
}

