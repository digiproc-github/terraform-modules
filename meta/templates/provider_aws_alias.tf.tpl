provider "aws" {
  alias   = "${alias}"
  version = "~> 2.40.0"

  region              = "${region}"
  allowed_account_ids = ["${account_id}"]
}
