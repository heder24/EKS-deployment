variable "number_of_instances" {
  description = "Number of instances to create and attach to ELB"
  type        = string
  default     = 1
}
#Security groups
variable "public_sg" {
  type    = string
  default = "prod-public-sg"
}
variable "private_sg" {
  type    = string
  default = "prod-private-sg"
}
variable "bastion_sg" {
  type    = string
  default = "prod-bastion-sg"
}

#Domain name
variable "domain_name" {
  type    = string
  default = "hederdevops.com"
}
variable "prod_domain_name" {
  type    = string
  default = "www.hederdevops.com"
}


variable "host_domain_name" {
  type    = string
  default = "hederdevops.com"
}

#health path
variable "health_path" {
  type    = string
  default = "/health.html"
}
#key
variable "key_name" {
  type    = string
  default = "main-us-east-2"
}


variable "base-role" {
  type    = string
  default = "base-ec2-role-1"
}

#zone name
variable "zone" {
  type    = string
  default = "hederdevops.com"
}
#bastion
variable "bastion" {
  type    = string
  default = "prod-bastion"
}
#user
variable "userarn" {
  type    = string
  default = "arn:aws:iam::312029113425:user/hredon"
}

variable "username" {
  type    = string
  default = "hredon"
}
variable "waf-name" {
  type    = string
  default = "prod"
}

variable "enable_logging" {
  type        = bool
  description = "Whether to associate Logging resource with the WAFv2 ACL."
  default     = false
}

variable "log_destination_arns" {
  type        = list(string)
  description = "The Amazon Kinesis Data Firehose, Cloudwatch Log log group, or S3 bucket Amazon Resource Names (ARNs) that you want to associate with the web ACL."
  default     = []
}


variable "region" {
  type    = string
  default = "us-east-2"
}

variable "cluster_name" {
  type    = string
  default = "prod"
}
#Keys
variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
  sensitive   = true
  default     = "AKIAURJTCNRI2EO27RUC"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
  sensitive   = true
  default     = "Jtz0K+k2Ti+li/L/T8sugkF6vW5q7M2G9xXgkOtC"
}
