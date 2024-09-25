resource "gitlab_group" "group" {
  name = var.group_name
  path = var.group_name
}

# Створення проектів
resource "gitlab_project" "projects" {
  for_each    = toset(var.project_names)
  name        = each.key
  namespace_id = gitlab_group.group.id
}

# Створення групового токену доступу
resource "gitlab_group_access_token" "group_access_token" {
  group          = gitlab_group.group.id
  name           = "${var.group_name}-access-token"
  scopes         = ["read_api", "write_repository"]
  expires_at  = "2024-12-31"
}

# Створення токену для розгортання
resource "gitlab_deploy_token" "deploy_token" {
  for_each    = gitlab_project.projects  # Проекти, згенеровані вище
  project     = each.value.id            # Доступ до кожного проекту через ключі
  name        = "deploy-token"
  username    = "deploy"
  scopes      = ["read_repository", "read_registry"]
  depends_on  = [gitlab_project.projects]  # Залежність від створення проектів
}

# Захист гілок
resource "gitlab_branch_protection" "branch_protection" {
  for_each     = gitlab_project.projects
  project      = each.value.id
  branch       = "main"
  push_access_level = "maintainer"
  merge_access_level = "developer"
}

# Групові змінні (GROUP_TOKEN і DEPLOY_TOKEN)
resource "gitlab_group_variable" "group_variable_token" {
  group = gitlab_group.group.id
  key   = "GROUP_TOKEN"
  value = gitlab_group_access_token.group_access_token.token
}

resource "gitlab_group_variable" "deploy_token_variable" {
  for_each = gitlab_deploy_token.deploy_token
  group    = gitlab_group.group.id
  key      = "DEPLOY_TOKEN_${replace(each.key, "-", "_")}"
  value    = each.value.token
}