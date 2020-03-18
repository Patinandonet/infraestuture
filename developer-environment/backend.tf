terraform {
  backend "gcs" {
    bucket = "patinando-deveveloper-environment-tfstate"
    credentials = "patinando-developerenvironment-87b9c7033028.json"
  }
}
