# Session 18 lab - covers exercises 04 (tags), 05 (variables), 06 (outputs),
# 07 (init/plan/apply), 08 (destroy) and 09 (state).
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "terraform-training"
}

resource "aws_s3_bucket" "state_demo" {
  bucket_prefix = "${var.project_name}-${var.environment}-"

  tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "Rohan Ranjan"
    RollNo      = "24BCS10428"
  }
}

output "bucket_id" {
  description = "The S3 bucket ID"
  value       = aws_s3_bucket.state_demo.id
}

output "bucket_name" {
  description = "The S3 bucket name"
  value       = aws_s3_bucket.state_demo.bucket
}

output "bucket_arn" {
  description = "The S3 bucket ARN"
  value       = aws_s3_bucket.state_demo.arn
}

output "bucket_region" {
  description = "The AWS region"
  value       = aws_s3_bucket.state_demo.region
}
