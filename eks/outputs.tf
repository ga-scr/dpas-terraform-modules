output "cluster_id" {
  value = aws_eks_cluster.eks.id
  # So that calling plans wait for the cluster to be available before attempting to use it
  depends_on = [null_resource.wait_for_cluster]
}

output "cluster_version" {
  value = aws_eks_cluster.eks.version
}

output "ami_image_id" {
  value = local.ami_id
}

output "node_instance_profile" {
  value = aws_iam_instance_profile.eks_node.id
}

output "node_security_group" {
  value = aws_security_group.eks_node.id
}

output "api_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "node_role_arn" {
  value = aws_iam_role.eks_node.arn
}

output "node_role_name" {
  value = aws_iam_role.eks_node.name
}

output "node_asg_name" {
  value = aws_autoscaling_group.node.name
}

output "oidc_arn" {
  value = try(aws_iam_openid_connect_provider.oidc_provider.0.arn, null)
}

output "oidc_url" {
  value = try(aws_iam_openid_connect_provider.oidc_provider.0.url, null)
}

output "vpc_id" {
  value = local.vpc_id
}

output "private_subnets" {
  value = local.vpc_private_subnets
}

output "database_subnets" {
  value = local.vpc_database_subnets
}
