variable "gitlab_token" {
  type = string
}

output "module_gitlab_token" {
  value = var.gitlab_token
}

