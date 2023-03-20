data "aws_eks_cluster" "my-eks-cluster" {
  name       = var.cluster-name
  depends_on = [aws_eks_cluster.eks-cluster]
}

data "aws_eks_cluster_auth" "my-eks-cluster" {
  name       = var.cluster-name
  depends_on = [aws_eks_cluster.eks-cluster]
}
