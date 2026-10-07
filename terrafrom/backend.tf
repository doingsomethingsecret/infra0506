terraform {
  backend "s3" {
    bucket = [name of you bucket]
    key    = "terraform/terraform.tfstate"
    region = "ap-south-1"
  }
}
