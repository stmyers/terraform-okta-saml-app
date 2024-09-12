locals {
  org_url = "my-org.okta.com"
  # the terraform provider has a bug and returns the entity_url in place of the entity_key
  entity_key = trimprefix(okta_app_saml.saml_app.entity_key, "http://www.okta.com/")
}

output "saml_metadata" {
  value       = okta_app_saml.saml_app.metadata
  description = "The raw SAML metadata in XML."
}

output "saml_app_id" {
  value       = okta_app_saml.saml_app.id
  description = "Okta ID of the application"
}

output "saml_app_label" {
  value       = okta_app_saml.saml_app.label
  description = "Name of application (user facing label)"
}

output "app_assign_group_id" {
  value       = var.single_app_assign_group ? null : okta_group.app_assign_group[0].id
  description = "Okta Group ID of app assign group created for group rule"
}

output "metadata_url" {
  description = "Public Metadata URL for SAML app"
  value       = "https://${local.org_url}/app/${local.entity_key}/sso/saml/metadata"
  # "https://my-org.okta.com/app/exk1234567890/sso/saml/metadata"
}
