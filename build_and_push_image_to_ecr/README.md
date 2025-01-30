Build and push image to ECR
============================

## Overview

The `Taskfile.yml` defines tasks for managing Docker images and interactions with AWS ECR. It includes tasks for logging
into ECR (`ecr-login`), building a Docker image (`build`), tagging the image (`tag`), and pushing the image to ECR (
`docker-push`). Additionally, there is a `multi-command` task that sequentially executes the `build`, `tag`, and
`docker-push` tasks. The file uses environment variables for configuration and provides summaries for each task.

## Description

The `Taskfile.yml` contains tasks for managing Docker images and interactions with AWS ECR. Here is a summary of each
task:

1. **ecr-login**:
    - **Commands**:
        - Print a message indicating the login to ECR.
        - Log into ECR using AWS CLI and Docker.
    - **Summary**: Login to ECR.

2. **build**:
    - **Commands**:
        - Print a message indicating the building of the Docker image.
        - Build the Docker image using the specified Dockerfile.
    - **Summary**: Build the Docker image.

3. **tag**:
    - **Commands**:
        - Print a message indicating the tagging of the Docker image.
        - Tag the Docker image with the specified tag.
    - **Summary**: Tag the image.

4. **docker-push**:
    - **Commands**:
        - Print a message indicating the pushing of the Docker image to ECR.
        - Push the Docker image to ECR.
    - **Summary**: Push the image to ECR.

5. **multi-command**:
    - **Dependencies**: `ecr-login`
    - **Commands**:
        - Execute the `build` task.
        - Execute the `tag` task.
        - Execute the `docker-push` task.
    - **Summary**: Build, tag, and push the image.