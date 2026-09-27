locals {
  project_name = "terraform-eks"
}

remote_state {
  backend = "s3"

  config = {
    bucket = "YOUR-TERRAFORM-STATE-BUCKET"

    key = "${path_relative_to_include()}/terraform.tfstate"

    region = "us-east-1"

    encrypt = true
  }
}