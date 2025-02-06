Provision infra with `Terraform`
==================================

# Summary

The `Taskfile.yml` defines a set of tasks for managing Terraform operations, including cleaning up Terraform files,
initializing, planning, applying, and destroying Terraform configurations. It also includes a task for selectively
destroying specific Terraform resources and a task to run a shell script (`run_tf.sh`) that executes multiple Terraform
commands. Each task has a description, a series of commands to execute, and optional aliases for easier invocation. The
file also sets environment variables and task-specific variables to streamline the Terraform workflow.

# Description

The `Taskfile.yml` defines a set of tasks for managing Terraform operations. Here is an explanation of each task:

1. **clean-tf-files**:
    - **Description**: Cleans up Terraform-related files.
    - **Commands**:
        - Deletes the `.terraform` directory.
        - Deletes `terraform.tfstate` and its backup.
        - Deletes `.terraform.lock.hcl`.
        - Deletes any `tf-plan*.out` files.
    - **Aliases**: `purge`

2. **tf-init**:
    - **Description**: Initializes Terraform.
    - **Commands**:
        - Runs `terraform init` to initialize the Terraform configuration.
    - **Aliases**: `init`

3. **tf-plan**:
    - **Description**: Generates a Terraform plan.
    - **Commands**:
        - Runs `terraform plan -out={{.TF_PLAN_FILE}}` to create a plan and save it to the specified file.
    - **Aliases**: `plan`

4. **tf-apply**:
    - **Description**: Applies the Terraform plan.
    - **Commands**:
        - Runs `terraform apply {{.TF_PLAN_FILE}}` to apply the previously generated plan.
    - **Aliases**: `apply`

5. **tf-destroy**:
    - **Description**: Destroys all Terraform-managed infrastructure.
    - **Commands**:
        - Runs `terraform destroy` to remove all resources.
    - **Aliases**: `destroy`

6. **tf-selective-destroy**:
    - **Description**: Destroys specific Terraform resources.
    - **Commands**:
        - Runs `terraform destroy -target=aws_s3_bucket.state_bucket -target=aws_dynamodb_table.state_lock_table` to
          selectively destroy specified resources.
    - **Aliases**: `selective-destroy`

7. **tf-auto**:
    - **Dependencies**: Runs the `clean-tf-files` task first.
    - **Commands**:
        - Executes the `run_tf.sh` script to run multiple Terraform commands.
    - **Summary**: Runs the `run_tf.sh` shell script for executing multiple Terraform commands.
    - **Aliases**: `auto`
