# Summary
The `taskfile.yml` defines tasks for managing AWS S3 buckets and creating directories within them. It provides commands to create a new S3 bucket, create a single directory, and create multiple directories in a specified S3 bucket. The environment variables allow for easy configuration of bucket names and directory lists.

## Description

1. `create-s3-bucket`
   - Checks if the S3 bucket specified by the `S3_BUCKET_NAME` environment variable exists using aws s3api head-bucket.
   - If the bucket does not exist, it creates the bucket in the region specified by `REGION` using aws s3api create-bucket.
   - Prints messages indicating whether the bucket was created or already exists.
  
2. `create-directory`
   - Creates a single "directory" (prefix) in the S3 bucket.
   - Uses the DIR environment variable for the directory name.
   - Runs `aws s3api put-object` to create an empty object with the key `${DIR}/` in the bucket, simulating a directory.
   - Prints confirmation messages before and after creation.

3. `create-multiple-directories`
   - Creates multiple "directories" (prefixes) in the S3 bucket.
   - Uses the `MULTIPLE_DIRS` environment variable, which should be a space-separated list of directory names.
   - Iterates over each directory name and runs `aws s3api put-object` for each, creating empty objects with keys for each directory.
   - Prints a message for each directory created.


## Environment Variables:
- `REGION`: AWS region for bucket creation.
- `S3_BUCKET_NAME`: Name of the S3 bucket to operate on.
- `DIR`: Name of a single directory to create.
- `MULTIPLE_DIRS`: Space-separated list of directory names to create sequentially. Ex. `raw_md processed_data logs backups`
