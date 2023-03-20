terraform {
  backend "s3" {
    bucket = "backend-bocket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
