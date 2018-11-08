terragrunt = {
  remote_state {
    backend = "s3"
    config {
      bucket         = "datagov-terraform-state"
      key            = "${path_relative_to_include()}/terraform.tfstate"
      region         = "us-east-1"
      encrypt        = true
      dynamodb_table = "datagov-lock-table"
    }
  }

}

aws_region = "us-east-1"
