#!/bin/bash

# Note: Give execution permissions to this file: `chmod +x ./run_tf.sh`

# Function to clean all Terraform related files and directories
clean_terraform() {
  echo "Cleaning Terraform-related files and directories..."
  rm -rf .terraform/ terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
  echo "Cleanup complete."
}

# Run Terraform init
run_terraform_init() {
  echo "Initializing Terraform..."
  terraform init
}

# Run Terraform plan
run_terraform_plan() {
  echo "Generating Terraform plan..."
  terraform plan -out=tfplan.out
}

# Ask whether to apply changes
confirm_and_apply() {
  read -p "Do you want to proceed with applying the changes? (y/n): " confirm
  case "$confirm" in
    y|Y|yes|YES)
      echo "Applying changes..."
      terraform apply "tfplan.out"
      ;;
    *)
      echo "Aborted!"
      ;;
  esac
}

# Main Script Execution
#clean_terraform
run_terraform_init
run_terraform_plan
confirm_and_apply
