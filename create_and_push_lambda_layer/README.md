Create zip for lambda layer, check size, and push the layer to s3
====================================================================

# Summary
This `taskfile.yml` automates the process of building, validating, and deploying an AWS Lambda layer for a Python project. It defines tasks to create a zip archive of the Lambda layer using a shell script, check the unzipped and zipped layer sizes to ensure they do not exceed AWS limits, and upload the resulting zip file to an S3 bucket. The file uses environment variables for configuration and includes aliases for convenience, streamlining the workflow for managing Lambda layer artifacts.

# Description
**1. create-layer-zip (alias: create-zip):**  
This task runs the `create_layer.sh` shell script. The script is expected to package your Python dependencies and code into a zip file suitable for use as an AWS Lambda layer. This is the first step in preparing your Lambda layer for deployment.

**2. check-layer-size (alias: check-size):**  
This task checks the size of the Lambda layer zip file to ensure it meets AWS Lambda's size restrictions.  
- It unzips the layer into a temporary directory and reports the unzipped size.
- It also reports the size of the zip file itself.
- If the unzipped size exceeds 250MB, it prints an error and exits with a failure code. Otherwise, it confirms the size is within limits.

**3. push-layer:**  
This task depends on `check-layer-size` (it will only run if the size check passes).  
- It verifies that the zip file exists in the specified directory.
- If the file is present, it uploads the zip file to the configured S3 bucket and directory using the AWS CLI.
- It prints a success message after uploading.

**Environment Variables:**  
The file uses environment variables to configure the S3 bucket name, S3 directory, zip file name, and zip directory, making it easy to change deployment targets or file names without editing the tasks themselves.
