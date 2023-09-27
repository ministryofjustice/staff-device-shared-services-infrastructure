#!/usr/bin/env bash

set -e

## This script will write a file with a report on the
## s3 bucket versioning status for all buckets within
## an AWS Account.

timestamp=$(date +%Y-%m-%dT%H-%M-%S)

results_dir="results"

aws_account_id=$(aws sts get-caller-identity --query "Account" --output text)

filename="${timestamp}_id-${aws_account_id}_s3_versioning.txt"

file="${results_dir}/${filename}"

s3buckets=$(aws s3api list-buckets --query "Buckets[].Name" --no-cli-pager --output json | jq '.[]' --raw-output)

mkdir -p "${results_dir}"

cat <<EOF >"${file}"
  S3 Bucket Versioning Status for AWS Account ID ${aws_account_id}
  at ${timestamp}


EOF

for bucket in ${s3buckets}
do
    echo "${bucket} $(aws s3api get-bucket-versioning --bucket "${bucket}")" >> "${file}"
done
