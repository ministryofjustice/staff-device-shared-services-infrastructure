#!/usr/bin/env bash

set -e

## This script will retrieve the AWS Secrets Manager
## Entries for this repository

secrets=$(aws secretsmanager list-secrets --no-cli-pager \
--query "SecretList[].Name" \
--filters Key=tag-key,Values=application Key=tag-value,Values=pttp-shared-services-infrastructure \
--output json | jq '.[]' --raw-output)

for secret in ${secrets}
do
  echo "${secret} -- $(aws secretsmanager get-secret-value --secret-id ${secret} --query "SecretString" --output text)"
done
