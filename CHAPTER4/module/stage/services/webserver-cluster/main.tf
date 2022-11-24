provider "aws" {
  region = "ap-northeast-2"
}

variable "environment" {
  description = "The name to use for all the environment"
  type        = string
  default     = "stage"
}

module "webserver_cluster" {
  #source = "../../../modules/services/webserver-cluster"
  source = "github.com/idealistchanu/study-T101Modules//services/webserver-cluster?ref=v0.0.2"

  environment            = var.environment
  cluster_name           = "webservers-${var.environment}"
  db_remote_state_bucket = "chanwoo-t101study-tfstate-week3-files"
  db_remote_state_key    = "${var.environment}/data-stores/mysql/terraform.tfstate"


  instance_type = "t2.nano"
  min_size      = 2
  max_size      = 2
}

resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 3
  recurrence            = "45 17 * * *"
  time_zone             = "Asia/Seoul"


  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 1
  max_size              = 10
  desired_capacity      = 1
  recurrence            = "0 17 * * *"
  time_zone             = "Asia/Seoul"


  autoscaling_group_name = module.webserver_cluster.asg_name
}
