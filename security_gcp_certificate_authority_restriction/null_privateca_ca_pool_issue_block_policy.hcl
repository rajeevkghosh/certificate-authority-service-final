module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-privateca-ca-pool-issue-block-undefined-null.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}