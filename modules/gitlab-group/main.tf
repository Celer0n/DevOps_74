/*variable "group_name" {
  type = string
}

variable "project_names" {
  type = list(string)
}

variable "create_deploy_token" {
  type    = bool
  default = false
}

resource "gitlab_group" "group" {
  name = var.group_name
}

resource "gitlab_project" "projects" {
  for_each    = toset(var.project_names)
  name        = each.value
  namespace_id = gitlab_group.group.id
}

resource "gitlab_group_access_token" "group_token" {
  group   = gitlab_group.group.id
  name    = "group_access_token"
  scopes  = ["api"]
}

resource "gitlab_group_variable" "group_token_variable" {
  group = gitlab_group.group.id
  key   = "GROUP_TOKEN"
  value = gitlab_group_access_token.group_token.token
}

resource "gitlab_deploy_token" "deploy_token" {
  count = var.create_deploy_token ? 1 : 0
  project_id = gitlab_project.projects[each.key].id
  name       = "deploy_token"
  scopes     = ["read_repository", "read_registry"]
}

resource "gitlab_group_variable" "deploy_token_variable" {
  count = var.create_deploy_token ? 1 : 0
  group = gitlab_group.group.id
  key   = "DEPLOY_TOKEN"
  value = gitlab_deploy_token.deploy_token[count.index].token
}*/