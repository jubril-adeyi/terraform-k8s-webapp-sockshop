# declaring the provider 

provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.my-eks-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.my-eks-cluster.certificate_authority.0.data)
  exec {
    api_version = var.k8s_api_version
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      var.cluster-name
    ]
  }
}