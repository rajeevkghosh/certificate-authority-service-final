module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-kms-crypto-key-failure-protection-level-empty.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
