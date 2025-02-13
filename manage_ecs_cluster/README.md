Manage ECS cluster
====================

## Overview

The `Taskfile.yml` defines tasks for managing an ECS cluster and task definitions. It includes tasks to create (
`create-cluster`) and delete (`delete-cluster`) an ECS cluster, register (`create-task-definition`) and deregister (
`deregister-task-definition`) ECS task definitions. The `create-cluster` task sets up a new ECS cluster with specified
tags, while the `delete-cluster` task removes the cluster after user confirmation. The `create-task-definition` task
registers a new task definition using a JSON file, and the `deregister-task-definition` task removes a specified task
definition after user confirmation. The file uses environment variables for configuration and includes aliases for each
task.

## Description

The `Taskfile.yml` contains tasks for managing an ECS cluster and task definitions. Here is a summary of each task:

1. **create-cluster**:
    - **Aliases**: `create-c`
    - **Commands**:
        - Print a message indicating the creation of an ECS cluster.
        - Create an ECS cluster using the `aws ecs create-cluster` command with the specified cluster name and tags.
        - Print a message indicating the execution of the cluster creation command.
    - **Environment Variables**:
        - `TAG_KEY`: `project`
        - `TAG_VALUE`: `visual_sonar`
    - **Summary**: Creating a new ECS cluster.

2. **delete-cluster**:
    - **Aliases**: `del-c`
    - **Prompt**: Warns the user that this will delete the ECS cluster and asks for confirmation.
    - **Commands**:
        - Delete the ECS cluster using the `aws ecs delete-cluster` command with the specified cluster name.

3. **create-task-definition**:
    - **Aliases**: `task-defn`
    - **Commands**:
        - Register a new task definition using the `aws ecs register-task-definition` command with the input JSON file
          specified by the `TASK_DEFN_FILE` environment variable.

4. **deregister-task-definition**:
    - **Aliases**: `deregister-td`
    - **Prompt**: Warns the user that they are about to deregister a task definition and asks for confirmation.
    - **Environment Variables**:
        - `DEFN_NAME`: `segmentation_fargate`
        - `DEFN_VERSION`: `2`
    - **Commands**:
        - Deregister the specified task definition using the `aws ecs deregister-task-definition` command with the task
          definition name and version.