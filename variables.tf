variable "app" {
  type        = string
  description = "Name of app in Okta (appears on dashboard)"
}

variable "app_assign_group" {
  type        = string
  description = "Name of group or matching set of groups (starts_with or regex) to assign all users assigned to app"
}

variable "single_app_assign_group" {
  type        = bool
  description = "True means a single group is used to assign users to app, False means all matching groups (starts_with or regex) are aggregated using a group rule"
  default     = true
}

variable "sso_acs_url" {
  type        = string
  description = "SSO URL, also known as Assertion Consumer Service (ACS) For SAML App"
}

variable "recipient_url" {
  type    = string
  default = ""
}

variable "destination_url" {
  type    = string
  default = ""
}

variable "entity_id" {
  type        = string
  description = "Audience URI (SP Entity ID)"
}

variable "default_relay_state" {
  type        = string
  description = "Relay State, if used"
  default     = ""
}
variable "name_id_format" {
  type        = string
  description = "Follow vendor instructions. Unspecified is usually ok"
  default     = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
}

variable "user_name_template" {
  type        = string
  description = "Value to pass as NameID"
  default     = "$${source.login}"
}

variable "user_name_template_type" {
  type        = string
  description = "BUILT_IN or CUSTOM if using expression"
  default     = "BUILT_IN"
}

variable "filter_type" {
  type        = string
  default     = "STARTS_WITH"
  description = "STARTS_WITH, EQUALS, CONTAINS, or REGEX"
}

variable "filter_value" {
  type    = string
  description = "Allows separate filter for SAML group expression"
  default = ""
}
variable "pass_groups_in_saml" {
  type        = bool
  description = "Pass list of groups"
  default     = false
}
variable "group_attribute_name" {
  type        = string
  description = "Name of attribute to pass in groups attribute of SAML assertion"
  default     = "groups"
}

variable "group_filter_type" {
  type        = string
  description = "Allows separate filter type for SAML group expression (STARTS_WITH or REGEX)"
  default = ""
}

variable "attribute_statements" {
  description = "A map of objects to create attribute statements for SAML assertion"
  type = map(object({
    name  = string
    value = string
  }))
  default = {}
}
variable "attribute_statements_namespace" {
  type        = string
  description = "Namespace The attribute namespace. It can be set to \"unspecified\", \"uri\", or \"basic\". \"urn:oasis:names:tc:SAML:2.0:attrname-format:\" is automatically set."
  default     = "unspecified"

  validation {
    condition     = can(regex("^(unspecified|basic|uri)$", var.attribute_statements_namespace))
    error_message = "Err: value must be either unspecified, basic, or uri."
  }
}

variable "hide_app_icon" {
  type        = bool
  description = "Do not display application icon to users (web and mobile)"
  default     = false
}

variable "admin_note" {
  type        = string
  description = "Application notes for admins."
  default     = ""
}

variable "acs_endpoints" {
  type    = list(string)
  default = []
}


variable "logo" {
  type        = string
  description = "Local file path to the logo. The file must be in PNG, JPG, or GIF format, and less than 1 MB in size."
  default     = null
}

variable "set_error_url" {
  type        = bool
  description = "Set the error url to redirect unassigned users to custom error page"
  default     = false
}

variable "authentication_policy" {
  type        = string
  description = "Authentication policy to apply to this app. You can use the exact name "
  default     = null
}