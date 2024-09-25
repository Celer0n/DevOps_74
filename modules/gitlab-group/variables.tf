variable "group_name" {
  description = "Назва групи"
  type        = string
  default     = "example-group"
}

variable "project_names" {
  description = "Назви проектів"
  type        = list(string)
  default     = ["project-1", "project-2", "project-3"] 
}

variable "create_deploy_token" {
  description = "Чи потрібно створювати deploy token?"
  type        = bool
  default     = true 
}