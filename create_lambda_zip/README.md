Create `.zip` for (all) Lambda files
=======================================

# Summary

The `Taskfile.yml` defines tasks for creating zip files for AWS Lambda functions written in Python and Node.js. It
includes tasks to zip Python Lambda functions by compressing `.py` files and to zip Node.js Lambda functions by
installing production dependencies and compressing the `index.js` file along with the `node_modules` directory. Each
task has a description, commands to execute, and is designed to be run from the directory containing the Lambda function
code.

# Description

The `Taskfile.yml` defines a set of tasks for creating zip files for AWS Lambda functions written in Python and Node.js.
Here is an explanation of each task:

1. **zip_python**:
    - **Description**: Creates a zip file for a Python Lambda function.
    - **Commands**:
        - Sets the directory variable to the provided path.
        - Sets the zip file name based on the directory name.
        - Changes to the specified directory.
        - Creates a zip file containing all `.py` files in the directory.
    - **Silent**: `false`

2. **zip_nodejs**:
    - **Description**: Creates a zip file for a Node.js Lambda function.
    - **Commands**:
        - Sets the directory variable to the provided path.
        - Sets the zip file name based on the directory name.
        - Changes to the specified directory.
        - Installs production dependencies using `npm ci` if `package-lock.json` exists, otherwise uses `npm install`.
        - Creates a zip file containing `index.js` and the `node_modules` directory, excluding lock files.
    - **Silent**: `false`