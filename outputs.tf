output "cluster_endpoint" {
  description = "Endpoint para a API do Kubernetes"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "ID do Security Group anexado ao cluster"
  value       = module.eks.cluster_security_group_id
}

output "region" {
  description = "Região da AWS configurada"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Nome do Cluster Kubernetes"
  value       = module.eks.cluster_name
}

output "configure_kubectl" {
  description = "Comando para configurar o kubectl localmente"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}