module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-privateca-ca-pool-issue-block-empty-failure.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
