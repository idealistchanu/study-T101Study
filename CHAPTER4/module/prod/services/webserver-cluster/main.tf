provider "aws" {
  region = "ap-northeast-2"
}

variable "environment" {
  description = "The name to use for all the cluster resources"
  type        = string
  default     = "prod"
}

module "webserver_cluster" {
  #source = "../../../modules/services/webserver-cluster"
  source = "github.com/idealistchanu/study-T101Modules//services/webserver-cluster?ref=v0.0.1"


  environment            = var.environment
  cluster_name           = "webservers-${var.environment}"
  db_remote_state_bucket = "chanwoo-t101study-tfstate-week3-files"
  db_remote_state_key    = "${var.environment}/data-stores/mysql/terraform.tfstate"

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 10
}
