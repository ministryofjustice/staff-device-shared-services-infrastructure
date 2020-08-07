# PTTP Shared Services Infrastructure

This creates the shared infrastructure for the main account, named Shared Services. This account is used to host CI/CD pipelines.

For the code that creates infrastructure for each environment please see [this repository](https://github.com/ministryofjustice/pttp-infrastructure).

To apply the Terraform in this project, you should be using a Terraform workspace named `ci`.

This repository holds the Terraform code to create a [CodeBuild](https://aws.amazon.com/codebuild/) / [CodePipeline](https://aws.amazon.com/codepipeline/) service in AWS.

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
        --description "Secret description" \
        --value "tops3cr3t" \
        --type SecureString \
        --key-id "kms key ID to encrypt with" \
        --overwrite
```