module "gitlab" {
  source = "./modules/gitlab-group"
}

# Налаштування провайдера GitLab
provider "gitlab" {
  token    = var.token
  base_url = var.base_url
  insecure = true
}