provider "aws" {
  default_tags {
    tags = {
      Account     = "GeeksHubs"
      Environment = "staging"
      Owner       = "nacho"
      terraform   = "true"
    }
  }
}
