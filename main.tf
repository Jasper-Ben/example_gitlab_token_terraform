terraform {
  required_version = ">= 0.15"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 3.14.0"
    }
  }
}

variable "gitlab_url" {
  type = string
}

variable "gitlab_user" {
  type = string
}

variable "gitlab_token" {
  type = string
}

module "dummy_module" {
  source       = "./dummy_module"
  gitlab_token = var.gitlab_token
}

provider "gitlab" {
  base_url = "${var.gitlab_url}/api/v4"
  token    = module.dummy_module.module_gitlab_token
  # early_auth_check disabled, as the availability of the token depends on a module.
  early_auth_check = false
}

data "gitlab_user" "user" {
  username = var.gitlab_user
}

resource "gitlab_personal_access_token" "example_token" {
  user_id = data.gitlab_user.user.user_id
  name    = "example_token"
  scopes  = ["write_registry"]
}
