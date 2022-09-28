provider "aws" {
  default_tags {
    tags = {
      Account     = "GeeksHubs"
      Environment = "production"
      Owner       = "nacho"
      terraform   = "true"
    }
  }
}
