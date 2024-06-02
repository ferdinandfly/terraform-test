terraform {
  backend "gcs" {
    bucket = "emy-terraform-backend"
    prefix = "terraform/prod"
  }
}