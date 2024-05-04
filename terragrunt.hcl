locals {
  # Automatically load subscription variables
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  location          = local.region_vars.locals.location
  environment       = local.environment_vars.locals.environment
  subscription_id   = local.subscription_vars.locals.subscription_id
}

# Generate Azure providers
generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.0.0"
        }
      }
    }

    provider "azurerm" {
        skip_provider_registration = true
        features {}
        subscription_id = "${local.subscription_id}"
    }
EOF
}

remote_state {
  backend = "azurerm"
  config = {
    subscription_id = "${local.subscription_id}"
    key = "${path_relative_to_include()}/terraform.tfstate"
    resource_group_name = "rg-terragrunt-backend-001"
    storage_account_name = "stterragruntbackend001"
    container_name = "environment-states"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Configure root level variables that all resources can inherit
inputs = merge(
  local.subscription_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals
)