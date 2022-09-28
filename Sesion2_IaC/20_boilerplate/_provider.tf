provider "aws" {
  default_tags {
    tags = {
      Account     = "GeeksHubs"
      Environment = "sandbox"
      Owner       = "<tu_nombre>"
      terraform   = "true"
    }
  }
}
