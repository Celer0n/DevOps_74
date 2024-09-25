/*output "group_id" {
  value = gitlab_group.group.id
}

output "project_ids" {
  value = [for project in gitlab_project.project : project.id]
}

output "group_token" {
  value = gitlab_group_access_token.group_token.token
}

output "deploy_token" {
  value = var.create_deploy_token ? gitlab_deploy_token.gitlab_srv_deploy.token : ""
}*/
