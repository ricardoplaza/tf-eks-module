resource "aws_kms_key" "kms-eks-ricardoplaza" {
  description = "EKS Secret Encryption Key for ricardoplaza"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id  = data.terraform_remote_state.infrastructure.outputs.vpc_id
  subnets = concat(flatten(data.terraform_remote_state.infrastructure.outputs.subnets_id_private))

  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true

  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs = list(var.peer_vpc_cidr)

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.kms-eks-ricardoplaza.arn
      resources        = ["secrets"]
    }
  ]

  tags = {
    Environment = "eks-${var.environment}"
    Project = "eks-${var.project}"
  }

  node_groups_defaults = {
    create_launch_template = true

    disk_type = "gp3"
    disk_size = 20
  }

  node_groups = {
    spot-node-group= {
      name = "spot-node-group"
   
      desired_capacity = 1
      min_capacity = 1
      max_capacity = 1

      instance_types = ["t3a.xlarge"]
      capacity_type  = "SPOT"

      k8s_labels = {
        Project = "eks-${var.project}"
        Environment = "eks-${var.environment}"
        NodeName = "spot-node-group"
        InstanceType = "spot"
        Name = "spot-node-group.eks-${var.project}-${var.environment}"
      },
      additional_tags = {
        NodeName = "spot-node-group"
        InstanceType = "spot"
        Name = "node-group.eks-${var.project}-${var.environment}"
      }
    },
    ondemand-node-group= {
      name = "ondemand-node-group"

      desired_capacity = 1
      min_capacity = 1
      max_capacity = 1

      instance_types = ["t3a.large"]

      k8s_labels = {
        Project = "eks-${var.project}"
        Environment = "eks-${var.environment}"
        NodeName = "ondemand"
        InstanceType = "ondemand"
        Name = "ondemand-node-group.eks-${var.project}-${var.environment}"
      },
      additional_tags = {
        NodeName = "ondemand"
        InstanceType = "ondemand"
        Name = "ondemand-node-group.eks-${var.project}-${var.environment}"
      }
    }
  }

  map_roles = [
    {
      rolearn = "arn:aws:iam::646771319519:role/eks-devops"
      username = "eks-devops"
      groups = ["system:masters"]
    },
    {
      rolearn = "arn:aws:iam::646771319519:role/eks-developers"
      username = "eks-developers"
      groups = ["eks-developers-role"]
    },
    {
      rolearn  = aws_iam_role.eks_spot_group_role.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  depends_on = [
    aws_iam_role.eks_spot_group_role,
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

}

resource "aws_iam_role_policy_attachment" "cert_manager_ro" {
  role       = module.eks.worker_iam_role_name
  policy_arn = var.cert_manager_policy_arn
}

resource "aws_iam_role_policy_attachment" "eks-s3-policy-attach" {
  role       = module.eks.worker_iam_role_name
}
