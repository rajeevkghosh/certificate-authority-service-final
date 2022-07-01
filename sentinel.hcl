/*mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-v2-alg.sentinel"
  }
}*/
mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-v2-modified.sentinel"
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
    source = "./mock-tfstate-v2-modified.sentinel"
  }
}