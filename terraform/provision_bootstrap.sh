#!/usr/bin/env bash

# Vars
bucket_name=tf-states-bucket
region=us-east-1
dynamodb_table_name=tf_states
read_capacity_units=5
write_capacity_units=5

no_pager="--no-cli-pager"

## =========== Create s3 bucket to store TF states ===========
# Check if the S3 bucket already exists
if aws s3api head-bucket --bucket "$bucket_name" $no_pager 2>/dev/null; then
  echo "S3 bucket [$bucket_name] already exists in region [$region]"
else
  # Create an S3 bucket to store Terraform states
  if aws s3api create-bucket --bucket "$bucket_name" --region "$region" $no_pager; then
    echo "S3 bucket [$bucket_name] created successfully in region [$region]"

    # Enable versioning for the bucket
    if aws s3api put-bucket-versioning --bucket "$bucket_name" --versioning-configuration Status=Enabled $no_pager; then
      echo "Versioning enabled for S3 bucket [$bucket_name]"
    else
      echo "Failed to enable versioning for S3 bucket [$bucket_name]"
    fi
  else
    echo "Failed to create S3 bucket [$bucket_name] in region [$region]"
  fi
fi


## =========== Create DynamoDB table to store TF state locks ===========
# Check if the DynamoDB table already exists
if aws dynamodb describe-table --table-name "$dynamodb_table_name" --region $region $no_pager &>/dev/null; then
  echo "DynamoDB table [$dynamodb_table_name] already exists in region [$region]"
else
  # Create DynamoDB table to store TF locks
  if aws dynamodb create-table \
      --table-name $dynamodb_table_name \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --provisioned-throughput ReadCapacityUnits=$read_capacity_units,WriteCapacityUnits=$write_capacity_units \
      --region $region \
      $no_pager; then
    echo "DynamoDB table [$dynamodb_table_name] created successfully in region [$region]"
  else
    echo "Failed to create DynamoDB table [$dynamodb_table_name] in region [$region]"
  fi
fi
