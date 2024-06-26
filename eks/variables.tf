variable "cluster_id" {
  default = "The name of your cluster. Used for the resource naming as identifier"
  type    = string
}

variable "cluster_version" {
  description = "EKS Version to use with this cluster"
  type        = string
}

variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "List of CIDR blocks which can access the Amazon EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable. For more information, see Amazon EKS Control Plane Logging documentation (https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html)"
  type        = list(string)
  default     = ["audit", "api", "authenticator"]
}

#--------------------------------------------------------------
# CloudWatch Log Group
#--------------------------------------------------------------
variable "create_cluster_cloudwatch_log_group" {
  description = "Determines whether a log group is created by this module for the cluster logs. If not, AWS will automatically create one if logging is enabled"
  type        = bool
  default     = true
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "Number of days to retain log events. Default retention - 30 days"
  type        = number
  default     = 30
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "If a KMS Key ARN is set, this key will be used to encrypt the corresponding log group. Please be sure that the KMS Key has an appropriate key policy (https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html)"
  type        = string
  default     = null
}

#--------------------------------------------------------------
# EKS Addons
#--------------------------------------------------------------

variable "cluster_addons" {
  description = "Map of cluster addon configurations to enable for the cluster. Addon name can be the map keys or set with `name`"
  type        = any
  default     = {}
}

#--------------------------------------------------------------
# VPC and Subnets
#--------------------------------------------------------------
variable "create_vpc" {
  type        = bool
  description = "Determines whether to create the VPC and subnets or to supply them. If supplied then subnets and tagging must be configured correctly for AWS EKS use - see AWS EKS VPC requirments documentation"
  default     = true
}

## Create VPC = false
variable "vpc_id" {
  type        = string
  description = "ID of the VPC to place EKS cluster. Use if 'create_vpc = false'"
  default     = ""
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnets to use for EKS cluster. Requires if 'create_vpc = false'"
  default     = []
}

variable "database_subnets" {
  type        = list(string)
  description = "A list of database subnets to use for database cluster. Requires if 'create_vpc = false'"
  default     = []
}

## Create VPC = true
variable "vpc_cidr" {
  type        = string
  description = "The network CIDR you wish to use for the VPC module subnets. Default is set to 10.0.0.0/16 for most use-cases. Requires 'create_vpc = true'"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of public cidrs, for all available availability zones. Used by VPC module to set up public subnets. Requires if 'create_vpc = true'. Example: ['10.0.0.0/22', '10.0.4.0/22', '10.0.8.0/22']"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidrs" {
  description = "List of private cidrs, for all available availability zones. Used by VPC module to set up private subnets. Requires if 'create_vpc = true'. Example: ['10.0.32.0/19', 10.0.64.0/19', '10.0.96.0/19']"
  type        = list(string)
  default     = []
}

variable "database_subnet_cidrs" {
  description = "List of database cidrs, for all available availability zones. Used by VPC module to set up database subnets. Requires if 'create_vpc = true'. Example: ['10.0.20.0/22', '10.0.24.0/22', '10.0.28.0/22']"
  type        = list(string)
  default     = []
}

variable "create_database_subnet_group" {
  description = "Determines whether to create database subnet group. Requires if 'create_vpc = true'"
  type        = bool
  default     = true
}

variable "database_subnet_group_name" {
  description = "Name of database subnet group. Default will be set to vpc name if not provided. Requires if 'create_vpc = true'"
  type        = string
  default     = null
}

variable "enable_vpc_s3_endpoint" {
  type        = bool
  description = "Determines whether to creates VPC S3 gateway endpoint resource. Default is set to 'false'"
  default     = false
}

variable "admin_access_CIDRs" {
  description = "Locks ssh and api access to these IPs"
  type        = map(string)
  default     = {}
}

#--------------------------------------------------------------
# Worker variables
#--------------------------------------------------------------
variable "ami_image_id" {
  description = "Overwrites the default ami (latest Amazon EKS)"
  type        = string
  default     = ""
}

variable "default_worker_instance_type" {
  description = "The default nodegroup worker instance type that the cluster nodes core components will run"
  type        = string
  default     = "t3.medium"
}

variable "min_nodes" {
  description = "The minimum number of on-demand nodes to run"
  type        = number
  default     = 0
}

variable "desired_nodes" {
  description = "Desired number of nodes only used when first launching the cluster"
  type        = number
  default     = 0
}

variable "max_nodes" {
  description = "Max number of nodes you want to run"
  type        = number
  default     = 0
}

variable "root_block_device_mappings" {
  description = "Specify root EBS volume properties"
  type        = any
  default = {
    device_name = "/dev/xvda"
    ebs = {
      volume_size           = 20
      volume_type           = "gp3"
      iops                  = 3000
      throughput            = 150
      encrypted             = true
      delete_on_termination = true
    }
  }
}

variable "additional_block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = any
  default     = {}
  # Example:
  # additional_block_device_mappings = {
  #   sda1 = {
  #     device_name = "/dev/sda1"
  #     ebs = {
  #       volume_size           = 20
  #       volume_type           = "gp3"
  #       iops                  = 3000
  #       throughput            = 150
  #       encrypted             = true
  #       kms_key_id            = aws_kms_key.ebs.arn
  #       delete_on_termination = true
  #     }
  #   }
  # }
}

variable "metadata_options" {
  description = "The metadata options for the instance launch-template. This specifies the exposure of the Instance Metadata Service to worker nodes. Default is set to uses IMSv1"
  type        = any
  default = {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }
  # NOTE: switch to IMSv2 (recommended option) for limiting access to instance metadata
  ## Reference: https://aws.github.io/aws-eks-best-practices/security/docs/iam/#restrict-access-to-the-instance-profile-assigned-to-the-worker-node
  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_protocol_ipv6          = "disabled"
  #   http_tokens                 = "required"
  #   http_put_response_hop_limit = 1
  #   instance_metadata_tags      = "enabled"
  # }
}

variable "extra_bootstrap_args" {
  type        = string
  description = "Additional bootstrap.sh command-line arguments (e.g. '--arg1=value --arg2')"
  default     = ""
}

variable "extra_userdata" {
  type        = string
  description = "Additional EC2 user data commands that will be passed to EKS nodes"
  default     = <<-USERDATA
  echo ""
  USERDATA
}

variable "iam_role_attach_cni_policy" {
  description = "Whether to attach the `AmazonEKS_CNI_Policy` IAM policy to the worker IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-node` DaemonSet pods via another method or nodes will not be able to join the cluster"
  type        = bool
  default     = true
}

#--------------------------------------------------------------
# Tags
#--------------------------------------------------------------
variable "environment" {
}

variable "namespace" {
}

variable "owner" {
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g. `map('StackName','XYZ')`"
  default     = {}
}

variable "extra_node_tags" {
  type        = map(string)
  description = "Additional tags for EKS nodes (e.g. `map('StackName','XYZ')`"
  default     = {}
}

#--------------------------------------------------------------
# aws-auth configmap
#--------------------------------------------------------------
variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_accounts" {
  description = "List of account maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

#--------------------------------------------------------------
# IRSA
#--------------------------------------------------------------
variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA"
  type        = bool
  default     = true
}

variable "openid_connect_audiences" {
  description = "List of OpenID Connect audience client IDs to add to the IRSA provider"
  type        = list(string)
  default     = []
}

variable "custom_oidc_thumbprints" {
  description = "Additional list of server certificate thumbprints for the OpenID Connect (OIDC) identity provider's server certificate(s)"
  type        = list(string)
  default     = []
}

