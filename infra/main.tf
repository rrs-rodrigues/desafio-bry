module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.aws_vpc_name
  cidr = var.aws_vpc_cidr

  azs             = var.aws_vpc_azs
  private_subnets = var.aws_vpc_private_subnets
  public_subnets  = var.aws_vpc_public_subnets

  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_vpn_gateway     = true
  map_public_ip_on_launch = true
  
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


# 2. O Cluster EKS Gerenciado
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  name    = var.aws_eks_name
  kubernetes_version = var.aws_eks_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Permite que você acesse o cluster pelo console/terminal
  enable_cluster_creator_admin_permissions = true
  endpoint_public_access           = true

  # Configuração dos 2 Workers (Node Group)
  eks_managed_node_groups = {
    workers = {
      name = "bry-workers"

      instance_types = var.aws_eks_managed_node_groups_instance_types
      
      min_size     = 2
      max_size     = 3
      desired_size = 2 # Atende ao requisito de 2 workers 

      tags = var.aws_project_tags
    }
  }

  tags = var.aws_project_tags
}