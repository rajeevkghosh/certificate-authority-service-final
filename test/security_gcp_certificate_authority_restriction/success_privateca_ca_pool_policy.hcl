module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-privateca-ca-pool-success.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
