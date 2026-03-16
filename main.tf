module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_vpc_azs
  private_subnets = var.aws_vpc_private_subnets
  public_subnets  = var.aws_vpc_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = var.aws_project_tags
}

#module "eks" {
#    source  = "terraform-aws-modules/eks/aws"
#    version = "21.15.1"
#
#    name    = "try-bry-eks"
#    kubernetes_version = var.aws_eks_version
#
#    vpc_id     = module.vpc.vpc_id
#    subnet_ids = module.vpc.private_subnets
#
#   
#    endpoint_public_access  = true
#
#    eks_managed_node_groups = var.aws_eks_node_groups
#}

