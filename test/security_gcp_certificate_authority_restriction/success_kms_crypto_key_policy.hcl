module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-kms-crypto-key-success.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
