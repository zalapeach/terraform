data "terraform_remote_state" "azdo" {
  backend = "remote"

  config = {
    organization = "zalapeach"
    workspaces = {
      name = "azdo"
    }
  }
}
