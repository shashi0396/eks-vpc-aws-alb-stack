terraform {
  backend "s3" {
    bucket = "terraform-remote-backend-md-123"
    key    = "dev/eks-vpc-aws-alb-stack/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
