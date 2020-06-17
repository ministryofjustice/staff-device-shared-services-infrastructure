terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    bucket     = "pttp-global-bootstrap-pttp-infrastructure-tf-remote-state"
    key        = "terraform/v1/state"
    lock_table = "pttp-global-bootstrap-pttp-infrastructure-terrafrom-remote-state-lock-dynamo"
  }
}
