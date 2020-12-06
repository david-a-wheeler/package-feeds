provider "google" {
  project     = "ossf-malware-analysis"
  region      = "us-central1"
}

terraform {
  backend "gcs" {
    bucket  = "ossf-feeds-tf-state"
    prefix  = "terraform/state"
  }
}

locals {
  services = [
    "cloudbuild.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudscheduler.googleapis.com",
  ]
}

resource "google_project_service" "services" {
  for_each           = toset(local.services)
  service            = each.value
  disable_on_destroy = false
}

resource "google_pubsub_topic" "feed-topic" {
  name = "feed-topic"
}

resource "google_storage_bucket" "feed-functions-bucket" {
  name = "feed-functions-bucket"
}