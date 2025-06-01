output "client_id" {
  value = { for k, v in random_string.client_id : k => v.id }
}

output "client_secret" {
  value     = { for k, v in random_password.client_secret : k => v.result }
  sensitive = true
}