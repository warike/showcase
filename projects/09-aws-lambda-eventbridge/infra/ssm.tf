locals {
  env_file = file("${path.module}/../workflow/.env")
  # Parse into map (very simple parser for KEY=VALUE lines)
  env_vars = {
    for line in split("\n", local.env_file) :
    split("=", line)[0] => split("=", line)[1]
    if length(trimspace(line)) > 0 && !startswith(trimspace(line), "#")
  }
}

# Create one SSM parameter per key/value
resource "aws_ssm_parameter" "warike_development_env_vars" {
  for_each    = local.env_vars
  name        = "/${local.project_name}/${each.key}"
  description = "Env var ${each.key} for ${local.project_name}"
  type        = "SecureString"
  value       = each.value
}