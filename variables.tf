variable "aws_region" {
  description = "Região usada para criar os recursos da AWS"
  type        = string
  nullable    = false
}

variable "aws_vpc_name" {
  description = "Nome da VPC a ser criado"
  type        = string
  nullable    = false
}

variable "aws_vpc_cidr" {
  description = "CIDR da VPC a ser criado"
  type        = string
  nullable    = false
}

variable "aws_vpc_azs" {
  description = "Lista de zonas de disponibilidade para VPC"
  type        = set(string)
  nullable    = false
}


variable "aws_vpc_private_subnets" {
  description = "Lista de CIDR para subnets privadas"
  type        = set(string)
  nullable    = false
}

variable "aws_vpc_public_subnets" {
  description = "Lista de CIDR para subnets públicas"
  type        = set(string)
  nullable    = false
}

variable "aws_eks_name" {
  description = "Nome do cluster EKS a ser criado"
  type        = string
  nullable    = false
}

variable "aws_eks_version" {
  description = "Versão do Kubernetes para o cluster EKS"
  type        = string
  nullable    = false
}

variable "aws_eks_managed_node_groups_instance_types" {
  description = "Lista de tipos de instância para os grupos de nós gerenciados do EKS"
  type        = set(string)
  nullable    = false

}

variable "aws_eks_node_groups" {
  description = "Configurações dos grupos de nós gerenciados do EKS"
  type = map(object({
    desired_capacity = number
    max_capacity     = number
    min_capacity     = number
    instance_types   = list(string)
  }))
  nullable = false
}

variable "aws_project_tags" {
  description = "Tags para os recursos da AWS"
  type        = map(string)
  nullable    = false
}