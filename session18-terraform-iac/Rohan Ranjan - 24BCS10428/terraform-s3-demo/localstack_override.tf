# LocalStack override (Terraform merges *_override.tf into the matching block).
# The rest of the configuration is unchanged real-AWS Terraform; deleting this file
# points the exact same code at a real AWS account.
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    s3  = "http://localhost:4566"
    sts = "http://localhost:4566"
    ec2 = "http://localhost:4566"
  }
}
