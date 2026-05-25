terraform {
  backend "s3" {
    bucket         = "dev-abhi-tf-bucket"
    region         = "us-east-1"
    key            = "End-to-End-Kubernetes-DevSecOps-Tetris-Project/EKS-TF/terraform.tfstate"
    encrypt        = true
    use_lockfile = true
  }
  required_version = ">=0.14.0"
  required_providers {
    aws = {
      version = ">= 5.49.0"
      source  = "hashicorp/aws"
    }
  }
}