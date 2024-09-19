provider "gitlab" {
  base_url = var.base_url
  token    = var.token
  insecure = true
}

resource "gitlab_group" "gitlab_srv" {
  name        = "developers"
  path        = "developers"
  description = "An example group"
}

# Create a project in the example group
resource "gitlab_project" "gitlab_srv" {
  name         = "testing project"
  description  = "An example project"
  namespace_id = gitlab_group.gitlab_srv.id
}


### Доделать
resource "gitlab_group_access_token" "gitlab_srv" {
  group        = "25"
  name         = "Example group access token"
  expires_at   = "2025-03-14"
  access_level = "developer"

  scopes = ["api"]
}

# Example Usage - Group
resource "gitlab_deploy_token" "gitlab_srv" {
  group = "developers"
  name  = "Example group deploy token"

  scopes = ["read_repository, read_registry, write_registry"]
}

# Example using dynamic block
resource "gitlab_branch_protection" "main" {
  project                = "12345"
  branch                 = "main"
  push_access_level      = "maintainer"
  merge_access_level     = "maintainer"
  unprotect_access_level = "maintainer"

  dynamic "allowed_to_push" {
    for_each = [50, 55, 60]
    content {
      user_id = allowed_to_push.value
    }
  }
}



