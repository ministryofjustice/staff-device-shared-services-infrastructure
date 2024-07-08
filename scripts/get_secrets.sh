#!/usr/bin/env bash

set -e

## This script will retrieve the AWS Secrets Manager

function nvvs-devops-monitor() {
  echo ""
	local tag_name="supported-application-secret-for"
  local application_name="nvvs-devops-monitor"

  local tag_name2=supported-application-environment
  local environment=${1}

  secrets=$(aws secretsmanager list-secrets --no-cli-pager \
  --query "SecretList[].Name" \
  --filters Key=tag-key,Values=${tag_name} Key=tag-value,Values=${application_name} \
  --filters Key=tag-key,Values=${tag_name2} Key=tag-value,Values=${environment} \
  --output json | jq '.[]' --raw-output)

	display_retrieved_secrets "${secrets}" "${application_name}" "${environment}"
}

function pttp-shared-services-infrastructure() {
  echo ""
  local tag_name=application
  local application_name="pttp-shared-services-infrastructure"

  local secrets=$(aws secretsmanager list-secrets --no-cli-pager \
  --query "SecretList[].Name" \
  --filters Key=tag-key,Values=${tag_name} Key=tag-value,Values=${application_name} \
  --output json | jq '.[]' --raw-output)

	display_retrieved_secrets "${secrets}" "${KEY}" "production"
}

function staff-infrastructure-certificate-services() {
  echo ""
  local tag_name=application
  local application_name="staff-infrastructure-certificate-services"

  local secrets=$(aws secretsmanager list-secrets --no-cli-pager \
  --query "SecretList[].Name" \
  --filters Key=tag-key,Values=${tag_name} Key=tag-value,Values=${application_name} \
  --output json | jq '.[]' --raw-output)

	display_retrieved_secrets "${secrets}" "${KEY}" "CI"
}

function display_retrieved_secrets() {
  local secrets=${1}
  local application_name="${2}"
  local environment="${3}"
  echo ""
	echo "Retreiving secrets for : application \"${application_name}\" environment \"${environment}\""
	echo ""
	for secret in ${secrets}
  do
    echo "${secret} -- $(aws secretsmanager get-secret-value --secret-id ${secret} --query "SecretString" --output text)"
  done
    echo ""
}

##
# Color  Variables
##
green='\e[32m'
blue='\e[34m'
clear='\e[0m'

##
# Color Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

menu(){
echo -ne "
Get secrets for
$(ColorGreen '1)') nvvs-devops-monitor development
$(ColorGreen '2)') nvvs-devops-monitor pre-production
$(ColorGreen '3)') nvvs-devops-monitor production
$(ColorGreen '4)') pttp-shared-services-infrastructure
$(ColorGreen '5)') staff-infrastructure-certificate-services
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) nvvs-devops-monitor "development" && nvvs-devops-monitor "shared";;
	        2) nvvs-devops-monitor "pre-production" && nvvs-devops-monitor "shared";;
	        3) nvvs-devops-monitor "production" && nvvs-devops-monitor "shared";;
	        4) pttp-shared-services-infrastructure ;;
	        5) staff-infrastructure-certificate-services ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Call the menu function
menu
