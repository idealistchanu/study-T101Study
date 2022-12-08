variable "names" {
  description = "A list of names"
  type        = list(string)
  default     = ["gasida", "akbun", "fullmoon"]
}

output "upper_names" {
  value = [for name in var.names : upper(name)]
}
