# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment_auto_approve "no_changes" {
  check {
    condition = context.plan.changes.total == 0
    reason    = "Plan contains too many changes for automatic approval."
  }
}

deployment_group "development_grp" {
  auto_approve_checks = [
    deployment_auto_approve.no_changes
  ]
}

deployment_auto_approve "no_destroys" {
  check {
    condition = context.plan.changes.remove == 0
    reason    = "Plan removes ${context.plan.changes.remove} resources."
  }
}

deployment_group "production_grp" {
  auto_approve_checks = [
    deployment_auto_approve.no_destroys
  ]
}


deployment "development" {
  inputs = {
    regions        = ["us-east-1"]
    role_arn       = "<YOUR_ROLE_ARN>"
    identity_token = identity_token.aws.jwt
    default_tags = {
      Stack       = "learn-stacks-deploy-aws",
      Environment = "dev"
    }
  }
}

deployment "production" {
  inputs = {
    regions        = ["us-east-1", "us-west-1"]
    role_arn       = "<YOUR_ROLE_ARN>"
    identity_token = identity_token.aws.jwt
    default_tags = {
      Stack       = "learn-stacks-deploy-aws",
      Environment = "prod"
    }
  }
}
