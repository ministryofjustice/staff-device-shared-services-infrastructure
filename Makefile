#!make
.DEFAULT_GOAL := help
SHELL := '/bin/bash'

CURRENT_TIME := `date "+%Y.%m.%d-%H.%M.%S"`
TERRAFORM_VERSION := `cat versions.tf 2> /dev/null | grep required_version | cut -d "\\"" -f 2 | cut -d " " -f 2`

LOCAL_IMAGE := ministryofjustice/nvvs/terraforms:latest
DOCKER_IMAGE := ghcr.io/ministryofjustice/nvvs/terraforms:latest

DOCKER_RUN := @docker run --rm \
				--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
				--env-file <(env | grep ^TF_VAR_) \
				--env-file <(env | grep ^ENV) \
				-e TFENV_TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
				-v `pwd`:/data \
				--workdir /data \
				--platform linux/amd64 \
				$(DOCKER_IMAGE)

DOCKER_RUN_IT := @docker run --rm -it \
				--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
				--env-file <(env | grep ^TF_VAR_) \
				--env-file <(env | grep ^ENV) \
				-e TFENV_TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
				-v `pwd`:/data \
				--workdir /data \
				--platform linux/amd64 \
				$(DOCKER_IMAGE)

export DOCKER_DEFAULT_PLATFORM=linux/amd64

include .env
export

.PHONY: debug
debug:  ## debug
	@echo "debug"
	$(info target is $@)
	@echo "debug ENV = $$ENV"

.PHONY: aws
aws:  ## provide aws cli command as an arg e.g. (make aws AWSCLI_ARGUMENT="s3 ls")
	$(DOCKER_RUN) /bin/bash -c "aws $$AWSCLI_ARGUMENT"

.PHONY: shell
shell: ## Run Docker container with interactive terminal
	$(DOCKER_RUN_IT) /bin/bash

.PHONY: fmt
fmt: ## terraform fmt
	$(DOCKER_RUN) terraform fmt --recursive

.PHONY: init
init:
	$(DOCKER_RUN) terraform init
	$(MAKE) workspace-select

.PHONY: init-upgrade
init-upgrade: ## terraform init -upgrade
	$(DOCKER_RUN) terraform init -upgrade
	$(MAKE) workspace-select

.PHONY: import
import: ## terraform import e.g. (make import IMPORT_ARGUMENT=module.foo.bar some_resource)
	$(DOCKER_RUN) terraform import $$IMPORT_ARGUMENT

.PHONY: workspace-list
workspace-list: ## terraform workspace list
	$(DOCKER_RUN) terraform workspace list

.PHONY: workspace-select
workspace-select: ## terraform workspace select
	$(DOCKER_RUN) terraform workspace select $$ENV || \
	$(DOCKER_RUN) terraform workspace new $$ENV

.PHONY: validate
validate: ## terraform validate
	$(DOCKER_RUN) terraform validate

.PHONY: plan-out
plan-out: ## terraform plan - output to timestamped file
	$(DOCKER_RUN) terraform plan -no-color > $$ENV.$(CURRENT_TIME).tfplan

.PHONY: plan
plan: ## terraform plan
	$(DOCKER_RUN) terraform plan

.PHONY: refresh
refresh: ## terraform refresh
	$(DOCKER_RUN) terraform refresh

.PHONY: output
output: ## terraform output (make output OUTPUT_ARGUMENT='--raw dns_dhcp_vpc_id')
	$(DOCKER_RUN) terraform output -no-color $$OUTPUT_ARGUMENT

.PHONY: apply
apply: ## terraform apply (make apply TARGET_ARGUMENT='-target=module.example_resource')
	$(DOCKER_RUN_IT) terraform apply $$TARGET_ARGUMENT
	$(DOCKER_RUN) /bin/bash -c "./scripts/ensure_cloudwatch_log_retention_policies.sh"

.PHONY: apply-target
apply-target: ## terraform apply-target (make apply-target TARGET_ARGUMENT='-target=module.example_resource')
	$(DOCKER_RUN_IT) terraform apply $$TARGET_ARGUMENT

.PHONY: state-list
state-list: ## terraform state list
	$(DOCKER_RUN) terraform state list

.PHONY: show
show: ## terraform show
	$(DOCKER_RUN) terraform show -no-color

## NOTE: Only one env, do not want this option.
#.PHONY: destroy
#destroy: ## terraform destroy
#	$(DOCKER_RUN) terraform destroy

.PHONY: lock
lock: ## terraform providers lock (reset hashes after upgrades prior to commit)
	rm .terraform.lock.hcl
	$(DOCKER_RUN) terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64

.PHONY: clean
clean: ## clean terraform cached providers etc
	rm -rf .terraform/ terraform.tfstate*

.PHONY: tfenv
tfenv: ## tfenv pin - terraform version from versions.tf
	tfenv use $(cat versions.tf 2> /dev/null | grep required_version | cut -d "\"" -f 2 | cut -d " " -f 2) && tfenv pin

.PHONY: get-secrets
get-secrets: ## Retrieve for inspection the secrets the terraform data lookup retrieves.
	$(DOCKER_RUN_IT) /bin/bash -c "./scripts/get_secrets.sh"

.PHONY: s3-audit
s3-audit: ## Write a report on the s3 bucket versioning status for all buckets within this AWS Account.
	$(DOCKER_RUN) /bin/bash -c "./scripts/s3_versioning_audit.sh"

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
