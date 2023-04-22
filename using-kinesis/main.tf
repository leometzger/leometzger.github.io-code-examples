terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS Region to apply the infrastructure"
}

variable "aws_kinesis_stream_name" {
  type        = string
  description = "Name of the data stream"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.aws_kinesis_stream_name
  shard_count      = 1
  retention_period = 24

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}

