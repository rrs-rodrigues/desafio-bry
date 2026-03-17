module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_vpc_azs
  private_subnets = var.aws_vpc_private_subnets
  public_subnets  = var.aws_vpc_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = merge(var.aws_project_tags, { "kubernetes.io/cluster/${var.aws_eks_name}" = "shared" })

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.aws_eks_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.aws_eks_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name               = "try-bry-eks"
  kubernetes_version = var.aws_eks_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_cluster_creator_admin_permissions = true

  endpoint_public_access = true

  eks_managed_node_groups = {

    try-bry-eks-node-group = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_types = var.aws_eks_managed_node_groups_instance_types
      tags           = var.aws_project_tags
    }
  }
tags           = var.aws_project_tags
}

