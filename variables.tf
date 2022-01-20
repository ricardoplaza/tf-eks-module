variable "availability_zones" {
  description = "Available availability zones"
  type        = list(string)
}

variable "public_key_path" {
  description = "Public part of the SSH key pair"
  default     = "config/certificates/id_rsa.pub"
}

variable "vpc_cidr_eks" {
  description = "CIDR of the new VPC"
}

# EKS vars
variable "cluster_name" {
  description = "Name for the eks cluster"
  default     = ""
}

variable "cluster_version" {
  description = "eks cluster version"
  default     = "1.20"
}

variable "cidr_blocks_workers_one" {
  description = "CIDR block for worker one"
  default     = []
  type        = list(string)
}

variable "cidr_blocks_workers" {
  description = "CIDR blocks for all workers"
  default     = []
  type        = list(string)
}

variable "cert_manager_policy_arn" {
  description = "AWS Certificate Manager Policy Arn"
  default     = "arn:aws:iam::aws:policy/AWSCertificateManagerReadOnly"
}

