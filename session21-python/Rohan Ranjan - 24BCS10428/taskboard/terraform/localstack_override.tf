# LocalStack override: used only for `terraform plan` on a machine without an AWS account.
# Delete this file to plan/apply against real AWS. (EKS needs real AWS to apply.)
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  endpoints {
    ec2  = "http://localhost:4566"
    eks  = "http://localhost:4566"
    iam  = "http://localhost:4566"
    sts  = "http://localhost:4566"
    kms  = "http://localhost:4566"
    logs = "http://localhost:4566"
  }
}
