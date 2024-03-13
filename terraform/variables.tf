variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
}


variable "region" {
  description = "The aws region. https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html"
  type        = string
  default     = "us-east-1"
}

variable "node_groups" {
  description = "EKS node groups"
  type        = map(any)
  default = {
  node-group-1 = {
      name         = "node-group"
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
      disk_size      = 20
      min_size     = 1
      max_size     = 5
      desired_size = 2
    }
  node-group-2 = {
      name         = "node-group"
      instance_types = ["t2.medium"]
      capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
      disk_size      = 20
      min_size     = 1
      max_size     = 5
      desired_size = 2
    }
  }
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {
  description = "Name to be used on all the resources as identifier. e.g. Project name, Application name"
  type = string
}

variable "vpc_cidrs" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "TimeApp"
    "Owner"       = "Dare Olufowobi"
  }
}

variable "node_iam_policies" {
  description = "List of IAM Policies to attach to EKS-managed nodes."
  type        = map(any)
  default = {
    1 = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    2 = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    3 = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
    4 = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "eks_version" {
  description = "Desired Kubernetes master version."
  type        = string
  default     = "1.26"
}

variable "cluster_name" {
  description = "Name of the cluster."
  type        = string
  default     = "timeapp"
}

variable "ingress_nginx_namespace" {
  type        = string
  description = "The nginx ingress namespace (it will be created if needed)."
  default     = "ingress-nginx"
}