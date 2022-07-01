module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "../../tfstate-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "mock-tfplan-v2-caentalg-null.sentinel"
  }
}
mock "tfstate/v2" {
  module {
    source = "mock-tfstate-v2-caentalg-null.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}