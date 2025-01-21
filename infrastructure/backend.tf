terraform {
  backend "remote" {
    organization = "levi"

    workspaces {
      name = "gmap-gcp-genai-nonprod-main-hle-gc1"
    }
  }
  required_providers {
    google = {
      version = ">= 5.0, <= 6.0"
    }
    google-beta = {
      version = ">= 5.0, <= 6.0"
    }
  }
}
