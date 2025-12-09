variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_initials" {
  type    = string
  default = "JSV"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "cluster_role_arn" {
  type    = string
  default = "arn:aws:iam::730335546358:role/c174285a4511470l11506634t1w730335-LabEksClusterRole-a7GGm8V2UeeU"
}

variable "node_role_arn" {
  type    = string
  default = "arn:aws:iam::730335546358:role/c174285a4511470l11506634t1w730335546-LabEksNodeRole-5CbQPh6hnInC"
}

variable "vpc_id" {
  type    = string
  default = "vpc-09eba15796328f763"
}

