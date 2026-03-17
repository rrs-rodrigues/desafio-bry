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


resource "aws_security_group" "k8s_sg" {
  name        = "k8s-common-sg"
  vpc_id      = module.vpc.vpc_id


  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }


  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "master" {
  ami           = "ami-04505e74c0741db8d" 
  instance_type = "c7i-flex.large"
  subnet_id     = module.vpc.public_subnets[0]
  
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]


  tags = merge(var.aws_project_tags, {
    Name = "k8s-master"
    Role = "master"
  })
}


resource "aws_instance" "worker" {
  count         = 2
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t3.small"
  subnet_id     = module.vpc.public_subnets[0]
  
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]


  tags = merge(var.aws_project_tags, {
    Name = "k8s-worker-${count.index}"
    Role = "worker"
  })
}