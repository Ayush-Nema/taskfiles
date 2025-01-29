Managing AWS Glue
===================

# Summary

The `Taskfile.yml` defines tasks for managing AWS Glue operations, including saving Glue scripts to S3, triggering Glue
jobs, purging S3 buckets, viewing S3 bucket contents and policies, and running multiple commands sequentially. Each task
has a description, commands to execute, optional variables, and aliases for easier invocation. The file sets environment
variables to streamline the workflow, such as AWS account details, region, and S3 bucket paths.

# Description

The `Taskfile.yml` defines a set of tasks for managing AWS Glue operations. Here is an explanation of each task:

1. **save-script**:
    - **Description**: Saves the Glue script to S3.
    - **Variables**:
        - `script_path`: Path to the local script file, defaulting to `UnstuckBanditDataProcessing.py`.
    - **Commands**:
        - Prints a message indicating the script is being saved to S3.
        - Copies the local script to the S3 bucket specified by `GLUE_SCRIPT_S3_DIRPATH` using the AWS profile
          `mac-dev`.
    - **Aliases**: `save`, `save-remote`

2. **trigger-glue**:
    - **Description**: Triggers the Glue job.
    - **Commands**:
        - Prints a message indicating the Glue job is being triggered.
        - Starts the Glue job with the name specified by `GLUE_NOTEBOOK`, passing the script location as an argument.
    - **Aliases**: `run`

3. **purge-s3**:
    - **Description**: Purges the specified S3 bucket.
    - **Commands**:
        - Prints a message indicating the S3 bucket is being purged.
        - Removes all objects in the `metadata` and `processed_data` directories of the `PROCESSED_BUCKET`.
        - Attempts to remove objects in a directory named `processed_data_$folder$`, ignoring errors if the directory
          does not exist.

4. **view-s3**:
    - **Description**: Lists the contents of an S3 bucket.
    - **Variables**:
        - `bucket_name`: Name of the S3 bucket to list, defaulting to `unstuck-bandit-raw`.
    - **Commands**:
        - Prints a message indicating the S3 bucket being listed.
        - Lists all objects in the specified S3 bucket using the AWS profile `mac-dev`.

5. **view-s3-policies**:
    - **Description**: Views the policies and ACLs of an S3 bucket.
    - **Variables**:
        - `bucket_name`: Name of the S3 bucket, defaulting to `unstuck-bandit-raw`.
    - **Commands**:
        - Prints a message indicating the S3 bucket policies are being viewed.
        - Retrieves and prints the bucket policy.
        - Prints a message indicating the S3 bucket ACLs are being viewed.
        - Retrieves and prints the bucket ACLs.

6. **multi-command**:
    - **Dependencies**: Runs the `save-script` task first.
    - **Commands**:
        - Runs the `purge-s3` task.
        - Runs the `trigger-glue` task.
    - **Summary**: Saves the script, purges the S3 bucket, and triggers the Glue job.
    - **Aliases**: `run-all`