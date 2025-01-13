# EKS is a managed Kubernetes service that abstracts control plane setup, scaling, and upgrades. You focus on deploying Kubernetes workloads, not managing Kubernetes infrastructure.
# The EKS module sets up the control plane, worker nodes, and configurations.

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = local.cluster_name
  # cluster_name    = var.cluster_name
  cluster_version = var.k8s_version
  subnet_ids      = module.vpc.private_subnets

  enable_irsa = true

  tags = {
    cluster = "demo"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 2          # Minimum number of EKS nodes
      max_size     = 6          # Maximum number of EKS nodes
      desired_size = 2          # Desired number of EKS nodes
    }
  }
}

