terraform {
  backend "s3" {
    bucket = "assignment05-terraform-state"
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}