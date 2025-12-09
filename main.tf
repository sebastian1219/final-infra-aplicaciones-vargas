# Obtener solo las subnets de la VPC en AZs soportadas por EKS
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c"]
  }
}

resource "aws_eks_cluster" "this" {
  name     = "etcluster${var.project_initials}-${var.env}"
  role_arn = var.cluster_role_arn
  version  = "1.29"

  vpc_config {
    subnet_ids = data.aws_subnets.selected.ids
  }

  tags = {
    Project = "SanaVI"
    Env     = var.env
  }
}

resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "default"
  node_role_arn   = var.node_role_arn
  subnet_ids      = data.aws_subnets.selected.ids

  scaling_config {
    desired_size = 3
    min_size     = 2
    max_size     = 6
  }

  instance_types = ["t3.small"]

  tags = {
    Project = "SanaVI"
    Env     = var.env
  }
}


