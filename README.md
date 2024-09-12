# Terraform module for provisioning Okta SAML App with app assignment group(s) included

## Features

The Okta App module will take the following actions:

1. Create a new Okta SAML App
2. (optionally) Create new Okta group and associated group rule that adds users in matching okta groups
3. Assigns group to SAML app granting all users in associated groups access
4. (optionally) Sends all matching to SAML assertion

## Usage

If `single_app_assign_group` is true, the group needs to exist already. The uncommented attributes are the minumim required, otherwise default SAML app settings will be used.

```hcl
module "my_app" {
  app         = "My App Label" # displayed to users 
  sso_acs_url = "https://myapp.com/saml/consume"
  entity_id   = "https://myapp.com/"

  ### Optional Okta SAML App settings with defaults
  ### In most cases, you don't need to changes these
  # recipient_url            = same as sso_acs_url
  # destination_url          = same as sso_acs_url
  # default_relay_state      = ""
  # acs_endpoints            = [] # comma separated list of URLs
  # subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  # subject_name_id_template = "$${user.userName}"
  # user_name_template       = "$${source.login}"
  # user_name_template_type  = "BUILT_IN" # Must use "CUSTOM" if changing user_name_template
  ###

  ### Group assigment to app, based on filter
  # filter_type            = "STARTS_WITH" #Use "REGEX" if more complex matching is needed
  # single_app_assign_group = true # If false, use STARTS_WITH or REGEX filter_type to assign multiple groups to single app
  app_assign_group = "my_app_group"
  ###

  ### Authentication Policy Name (use exact name of Authentication policy )
  authentication_policy = "Any Two Factors"

  ### Logo
  # Place a png, jpg, or gif in the root of the repo and set here.
  # logo = "logo.png"

  ### Set Error URL if user is unassigned. This redirects user to a custom error page.
  # set_error_url = true # default false 

  ### Misc App Settings
  admin_note = "App owner: team name"
  # hide_app_icon            = false # Hides both web/mobile icons from Okta Apps dashboard
  ###

  # Exmaples only - remove if SAML attributes aren't needed
  /*attribute_statements = {
    "email" = {
      name      = "email"
      value     = "user.email"
    },
    "Username" = {
      name      = "Username"
      value     = "user.sAMAccountName"
    }
  }*/
  # attribute_statements_namespace = ""urn:oasis:names:tc:SAML:2.0:attrname-format:basic" # this is default if not specified

  # To send groups in SAML assertion, set to true and set attribute name here
  # pass_groups_in_saml  = false
  # group_attribute_name = "groups"

}
```

* Manual App assignments to this app are ignored by Terraform, and won't be overwritten on subsequent runs

## Examples

## TODO

1. Add ability to manage app user profile

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.7 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_okta"></a> [okta](#provider\_okta) | 4.6.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [okta_app_group_assignment.app_assign_app_assign_group](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_group_assignment) | resource |
| [okta_app_group_assignment.app_assign_single_app_assign_group](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_group_assignment) | resource |
| [okta_app_saml.saml_app](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/app_saml) | resource |
| [okta_group.app_assign_group](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group) | resource |
| [okta_group_rule.aggregate_app_assign_groups](https://registry.terraform.io/providers/okta/okta/latest/docs/resources/group_rule) | resource |
| [okta_group.single_app_assign_group](https://registry.terraform.io/providers/okta/okta/latest/docs/data-sources/group) | data source |
| [okta_policy.authentication_policy](https://registry.terraform.io/providers/okta/okta/latest/docs/data-sources/policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acs_endpoints"></a> [acs\_endpoints](#input\_acs\_endpoints) | n/a | `list(string)` | `[]` | no |
| <a name="input_admin_note"></a> [admin\_note](#input\_admin\_note) | Application notes for admins. | `string` | `""` | no |
| <a name="input_app"></a> [app](#input\_app) | Name of app in Okta (appears on dashboard) | `string` | n/a | yes |
| <a name="input_app_assign_group"></a> [app\_assign\_group](#input\_app\_assign\_group) | Name of group or matching set of groups (starts\_with or regex) to assign all users assigned to app | `string` | n/a | yes |
| <a name="input_attribute_statements"></a> [attribute\_statements](#input\_attribute\_statements) | A map of objects to create attribute statements for SAML assertion | <pre>map(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `{}` | no |
| <a name="input_attribute_statements_namespace"></a> [attribute\_statements\_namespace](#input\_attribute\_statements\_namespace) | Namespace The attribute namespace. It can be set to "unspecified", "uri", or "basic". "urn:oasis:names:tc:SAML:2.0:attrname-format:" is automatically set. | `string` | `"unspecified"` | no |
| <a name="input_authentication_policy"></a> [authentication\_policy](#input\_authentication\_policy) | Authentication policy to apply to this app. You can use the exact name | `string` | `null` | no |
| <a name="input_default_relay_state"></a> [default\_relay\_state](#input\_default\_relay\_state) | Relay State, if used | `string` | `""` | no |
| <a name="input_destination_url"></a> [destination\_url](#input\_destination\_url) | n/a | `string` | `""` | no |
| <a name="input_entity_id"></a> [entity\_id](#input\_entity\_id) | Audience URI (SP Entity ID) | `string` | n/a | yes |
| <a name="input_filter_type"></a> [filter\_type](#input\_filter\_type) | STARTS\_WITH, EQUALS, CONTAINS, or REGEX | `string` | `"STARTS_WITH"` | no |
| <a name="input_filter_value"></a> [filter\_value](#input\_filter\_value) | Allows separate filter for SAML group expression | `string` | `""` | no |
| <a name="input_group_attribute_name"></a> [group\_attribute\_name](#input\_group\_attribute\_name) | Name of attribute to pass in groups attribute of SAML assertion | `string` | `"groups"` | no |
| <a name="input_group_filter_type"></a> [group\_filter\_type](#input\_group\_filter\_type) | Allows separate filter type for SAML group expression (STARTS\_WITH or REGEX) | `string` | `""` | no |
| <a name="input_hide_app_icon"></a> [hide\_app\_icon](#input\_hide\_app\_icon) | Do not display application icon to users (web and mobile) | `bool` | `false` | no |
| <a name="input_logo"></a> [logo](#input\_logo) | Local file path to the logo. The file must be in PNG, JPG, or GIF format, and less than 1 MB in size. | `string` | `null` | no |
| <a name="input_name_id_format"></a> [name\_id\_format](#input\_name\_id\_format) | Follow vendor instructions. Unspecified is usually ok | `string` | `"urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"` | no |
| <a name="input_pass_groups_in_saml"></a> [pass\_groups\_in\_saml](#input\_pass\_groups\_in\_saml) | Pass list of groups | `bool` | `false` | no |
| <a name="input_recipient_url"></a> [recipient\_url](#input\_recipient\_url) | n/a | `string` | `""` | no |
| <a name="input_set_error_url"></a> [set\_error\_url](#input\_set\_error\_url) | Set the error url to redirect unassigned users to custom error page | `bool` | `false` | no |
| <a name="input_single_app_assign_group"></a> [single\_app\_assign\_group](#input\_single\_app\_assign\_group) | True means a single group is used to assign users to app, False means all matching groups (starts\_with or regex) are aggregated using a group rule | `bool` | `true` | no |
| <a name="input_sso_acs_url"></a> [sso\_acs\_url](#input\_sso\_acs\_url) | SSO URL, also known as Assertion Consumer Service (ACS) For SAML App | `string` | n/a | yes |
| <a name="input_user_name_template"></a> [user\_name\_template](#input\_user\_name\_template) | Value to pass as NameID | `string` | `"${source.login}"` | no |
| <a name="input_user_name_template_type"></a> [user\_name\_template\_type](#input\_user\_name\_template\_type) | BUILT\_IN or CUSTOM if using expression | `string` | `"BUILT_IN"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_assign_group_id"></a> [app\_assign\_group\_id](#output\_app\_assign\_group\_id) | Okta Group ID of app assign group created for group rule |
| <a name="output_metadata_url"></a> [metadata\_url](#output\_metadata\_url) | Public Metadata URL for SAML app |
| <a name="output_saml_app_id"></a> [saml\_app\_id](#output\_saml\_app\_id) | Okta ID of the application |
| <a name="output_saml_app_label"></a> [saml\_app\_label](#output\_saml\_app\_label) | Name of application (user facing label) |
| <a name="output_saml_metadata"></a> [saml\_metadata](#output\_saml\_metadata) | The raw SAML metadata in XML. |
<!-- END_TF_DOCS -->
