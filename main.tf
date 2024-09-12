resource "okta_group" "app_assign_group" {
  count                             = var.single_app_assign_group ? 0 : 1
  name                              = "app_assign_${var.app}"
  description                       = "TF managed. Aggregate app assignment group of all matching groups for ${var.app}, if single_app_assign_group is false"
}

resource "okta_group_rule" "aggregate_app_assign_groups" {
  count                             = var.single_app_assign_group ? 0 : 1
  name                              = substr("TF-${var.app}",0,50) # Max length for group rule name is 50
  status                            = "ACTIVE"
  group_assignments                 = [okta_group.app_assign_group[0].id]
  expression_type                   = "urn:okta:expression:1.0"
  expression_value                  = (var.filter_type == "REGEX" ? "isMemberOfGroupNameRegex(\"${var.app_assign_group}\")" : "isMemberOfGroupNameStartsWith(\"${var.app_assign_group}\")")
}

resource "okta_app_saml" "saml_app" {
  label                             = var.app
  sso_url                           = var.sso_acs_url
  acs_endpoints                     = var.acs_endpoints
  recipient                         = (var.recipient_url != "" ? var.recipient_url : var.sso_acs_url)
  destination                       = (var.destination_url != "" ? var.destination_url : var.sso_acs_url)
  audience                          = var.entity_id
  default_relay_state               = var.default_relay_state

  # SAML Defaults
  subject_name_id_format            = var.name_id_format
  subject_name_id_template          = "$${user.userName}"
  user_name_template                = var.user_name_template
  user_name_template_type           = var.user_name_template_type
  user_name_template_push_status    = (var.user_name_template_type == "CUSTOM" ? "PUSH" : "")
  response_signed                   = true
  assertion_signed                  = true
  signature_algorithm               = "RSA_SHA256"
  digest_algorithm                  = "SHA256"
  honor_force_authn                 = false
  authn_context_class_ref           = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"

  # Authentication Policy to apply to this app
  authentication_policy             = (var.authentication_policy != null ? data.okta_policy.authentication_policy[0].id : null)

  logo                              = var.logo != null ? "${path.root}/${var.logo}" : null

  accessibility_error_redirect_url  = var.set_error_url ? "https://my-custom-error-url.com/error" : null

  # Okta App Setting Defaults
  hide_web                          = var.hide_app_icon
  hide_ios                          = var.hide_app_icon

  admin_note                        = "Managed by Terraform. ${var.admin_note}"

  # Group Attribute statement
  dynamic "attribute_statements" {
    for_each                        = var.pass_groups_in_saml == true ? [1] : []
    content {
      type                          = "GROUP"
      name                          = var.group_attribute_name
      namespace                     = "urn:oasis:names:tc:SAML:2.0:attrname-format:${var.attribute_statements_namespace}"
      filter_type                   = (var.group_filter_type != "" ? var.group_filter_type : var.filter_type)
      filter_value                  = (var.filter_value != "" ? var.filter_value : var.app_assign_group)
    }
  }

  # Creates attribute_statements block to support multiple attributes to add to SAML assertion
  dynamic "attribute_statements" {
    for_each                        = var.attribute_statements

    content {
      type                          = "EXPRESSION"
      namespace                     = "urn:oasis:names:tc:SAML:2.0:attrname-format:${var.attribute_statements_namespace}"
      name                          = attribute_statements.value.name
      values                        = [attribute_statements.value.value]
    }
  }
}

resource "okta_app_group_assignment" "app_assign_app_assign_group" {
  count                             = var.single_app_assign_group ? 0 : 1
  app_id                            = okta_app_saml.saml_app.id
  group_id                          = okta_group.app_assign_group[0].id
}

data "okta_group" "single_app_assign_group" {
  count                             = var.single_app_assign_group ? 1 : 0
  name                              = var.app_assign_group
  include_users                     = false
}
resource "okta_app_group_assignment" "app_assign_single_app_assign_group" {
  count                             = var.single_app_assign_group ? 1 : 0
  app_id                            = okta_app_saml.saml_app.id
  group_id                          = data.okta_group.single_app_assign_group[0].id
}

data "okta_policy" "authentication_policy" {
  count                             = var.authentication_policy != null ? 1 : 0
  name                              = var.authentication_policy
  type                              = "ACCESS_POLICY"
}