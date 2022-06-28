mock "tfplan/v2" {
  module {
    source = "mock-pre-apply/mock-tfplan-v2-modified.sentinel"
  }
}
module "tfplan-functions" {
    source = "./tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "./tfstate-functions.sentinel"
}

mock "tfstate/v2" {
  module {
    source = "mock-post-apply/mock-tfstate-v2-modified.sentinel"
  }
}
