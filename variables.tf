variable "aws_region" {
  description = "AWS region for the resources"
  default     = "us-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

#variable "cluster_name" {
#  description = "EKS cluster name"
#  default     = "my-eks"
#}

variable "k8s_version" {
  description = "Eks cluster version"
  default = "1.27"
}

