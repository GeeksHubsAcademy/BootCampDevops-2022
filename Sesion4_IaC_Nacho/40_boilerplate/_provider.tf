provider "aws" {
  default_tags {
    tags = {
      Account     = "GeeksHubs"
      Environment = "sandbox"
      Owner       = "nacho"
      terraform   = "true"
    }
  }
}
