terraform {
  backend "gcs" {
    bucket = "patinando-net-int-tfstate"
  }
}