resource "random_string" "client_id" {
  for_each = var.authentik_application
  length   = 40
  special  = false
}

resource "random_password" "client_secret" {
  for_each = var.authentik_application
  length   = 128
  special  = true
}

data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-explicit-consent"
}

data "authentik_flow" "default-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_oauth2" "this" {
  for_each = var.authentik_application
  name                   = each.key
  client_id              = random_string.client_id[each.key].id
  client_secret          = random_password.client_secret[each.key].result
  authorization_flow     = data.authentik_flow.default-authorization-flow.id
  invalidation_flow      = data.authentik_flow.default-invalidation-flow.id
  refresh_token_validity = var.refresh_token_validity
  allowed_redirect_uris  = each.value.allowed_redirect_uris
  property_mappings      = var.property_mappings
  sub_mode               = var.sub_mode
}

resource "authentik_policy_expression" "policy" {
  name       = var.policy_expression.name
  expression = var.policy_expression.expression
}

resource "authentik_policy_binding" "app-access" {
  for_each = var.authentik_application
  target   = authentik_application.this[each.key].uuid
  policy   = authentik_policy_expression.policy.id
  order    = 0
}

resource "authentik_application" "this" {
  for_each          = var.authentik_application
  name              = try(each.value.name, each.key)
  slug              = each.key
  protocol_provider = authentik_provider_oauth2.this[each.key].id
}
