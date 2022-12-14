variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["gasida", "akbun", "fullmoon"]
}

variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

