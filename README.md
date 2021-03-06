# PTTP Shared Services Infrastructure

This creates the shared infrastructure for the main account, named Shared Services. This account is used to host CI/CD pipelines.

For the code that creates infrastructure for each environment please see [this repository](https://github.com/ministryofjustice/staff-device-logging-infrastructure), as an example.


This repository holds the Terraform code to create a [CodeBuild](https://aws.amazon.com/codebuild/) / [CodePipeline](https://aws.amazon.com/codepipeline/) service in AWS.

## Applying the terraform

To apply the Terraform in this project using [AWS Vault](https://github.com/99designs/aws-vault) to authenticate:

1. Create a profile for the AWS Shared Services account, if not done so already
```
aws-vault add moj-shared-services
```
This will prompt you for the values of your AWS Shared Services account's IAM user.

2. Prepare your working directory for Terraform

```
aws-vault exec moj-shared-services -- terraform init
```
3. Select the `ci` workspace, to apply the changes in
 ```
 aws-vault exec moj-shared-services -- terraform workspace select ci
 ```
4. Apply the changes
```
aws-vault exec moj-shared-services -- make apply
```

>Note: When inspecting the terraform plan, the OAuth tokens for each pipeline will show as changed every time.

## How to use this repo

The source code in this repository is provided only as a reference.

Please speak to someone on the PTTP team to get a pipeline set up for your own project.

The pipeline you set will be integrated with a GitHub repository, and will build your project according to your [buildspec](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html) files.

Depending on your build process, you may require 3 files to do linting, testing and deployment.

### Linting

If you are doing static code analysis as part of your build, please create a `buildspec.lint.yml` file, and place it in the root of your project.

example:

```yaml
version: 0.2

phases:
  install:
    commands:
      - make lint
```

### Testing

To run automated tests, create a `buildspec.test.yml` file, and place it in the root of your project.

example:

```yaml
version: 0.2

phases:
  install:
    commands:
      - make test
```

### Deployment

For deployments, create a `buildspec.yml` file.

example:

```yaml
version: 0.2

env:
  variables:
    key: "value"
    key: "value"

phases:
  install:
    commands:
      - pip install boto3
      - wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
      - unzip terraform_0.12.24_linux_amd64.zip
      - mv terraform /bin
      - terraform init
  build:
    commands:
      - terraform apply --auto-approve
```

## To create your own Pipeline

For experimenting with AWS CodePipeline / CodeBuild, you can execute the Terraform in this repository.

An OAuth token is required to pull your source code from Github.

Create an access token for your repository and add it to a `.tfvars` file in the root of the project.

```shell script
github_oauth_token = "abc123"
```

Run Terraform 

```shell script
make apply
```

## Secrets management

We use SSM Parameter store for all secrets.

These secrets are decrypted at build time on CI to inject into Terraform.

### To add or update a secret:

``` shell script
aws-vault exec moj-pttp-shared-services -- aws ssm put-parameter --name "/your/top/secret/name" \
  --key-id "kms key ID to encrypt with" \
  --description "Secret description" \
  --type SecureString \
  --value "tops3cr3t" \
  --overwrite
```