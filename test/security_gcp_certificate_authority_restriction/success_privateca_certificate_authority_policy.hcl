module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-privateca-certificate-authority-success.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}
