module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-kms-crypto-key-null.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
