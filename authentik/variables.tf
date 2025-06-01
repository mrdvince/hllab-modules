variable "refresh_token_validity" {
  default = "days=1"
}

variable "property_mappings" {
  # authentik default OAuth Mapping: OpenID 'email' 
  # authentik default OAuth Mapping: OpenID 'openid 
  # authentik default OAuth Mapping: OpenID 'profile'
  default = [
    "4c94fd1d-1655-498f-94dc-e3be8506e0ec",
    "8bb80d61-1994-4538-9942-633b45ecd879",
    "660390cb-184a-4260-a4f0-7d69488a3037",
  ]
}

variable "sub_mode" {
  default = "hashed_user_id"
}

variable "policy_expression" {
  type = map(any)
}

variable "authentik_application" {
  type = map(any)
}

variable "app_meta_icon" {
  default = null
}