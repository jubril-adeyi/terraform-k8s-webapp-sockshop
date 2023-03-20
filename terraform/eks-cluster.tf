
// kubenetes provider block to define provider

data "aws_eks_cluster" "my-eks-cluster" {
  name       = var.cluster-name
  depends_on = [aws_eks_cluster.eks-cluster]
}

data "aws_eks_cluster_auth" "my-eks-cluster" {
  name       = var.cluster-name
  depends_on = [aws_eks_cluster.eks-cluster]
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

// creating IAM Role with neccesary policies for creation of cluster

resource "aws_iam_role" "eks-cluster-role" {
  name = "eksClusterRole1e"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

// creating cluster

resource "aws_eks_cluster" "eks-cluster" {
  name     = "Cluster-01"
  role_arn = aws_iam_role.eks-cluster-role.arn
  vpc_config {
    subnet_ids = [
      aws_subnet.eks-subnets1.id,
      aws_subnet.eks-subnets2.id,
      aws_subnet.eks-subnets3.id,
      aws_subnet.eks-subnets4.id
    ]
    security_group_ids      = [aws_security_group.eks-sg.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }
  tags = {
    environment = "dev"
    application = "app"
  }



  depends_on = [aws_iam_role_policy_attachment.eks-cluster-role-AmazonEKSClusterPolicy]
}

// creating IAM role for woeker node group creation

resource "aws_iam_role" "eks-node-role" {
  name = "eksNodeRole"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-node-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "eks-node-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-role.name
}

resource "aws_iam_role_policy_attachment" "eks-node-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-role.name
}

// worker node group creation
resource "aws_eks_node_group" "eks-node-grp" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "Node-group-01"
  node_role_arn   = aws_iam_role.eks-node-role.arn

  scaling_config {
    desired_size = 3
    max_size     = 4
    min_size     = 3
  }

  remote_access {
    ec2_ssh_key               = var.ssh_key_name
    source_security_group_ids = []
  }

  subnet_ids = [
    aws_subnet.eks-subnets1.id,
    aws_subnet.eks-subnets2.id,
    aws_subnet.eks-subnets3.id,
    aws_subnet.eks-subnets4.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = [var.node-instance-type]


  update_config {
    max_unavailable = 2
  }

  labels = {
    role = "general"
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks-node-role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-node-role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-node-role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
