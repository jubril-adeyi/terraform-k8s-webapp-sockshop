# // vpc variables 


variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "sets the region"
}

variable "cidr_blocks" {
  type        = string
  default     = "10.0.0.0/16"
  description = "vpc CIDR blocks"
}


# // sg variables 
variable "inbound_ports" {
  type        = list(number)
  default     = [0]
  description = "ports for the inbound rules"
}

///eks-cluster variables

variable "cluster-name" {
  type    = string
  default = "Cluster-01"
}

variable "ssh_key_name" {
  type    = string
  default = "key"
}

variable "k8s_api_version" {
  type    = string
  default = "client.authentication.k8s.io/v1beta1"
}

variable "node-instance-type" {
  type    = string
  default = "t3.medium"
}

//postgres credentials 

variable "postgres_password" {
  type    = string
  default = "cG9zdGdyZXM="
}

variable "postgres_username" {
  type    = string
  default = "cG9zdGdyZXM="
}

