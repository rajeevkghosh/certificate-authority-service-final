module "tfplan-functions" {
  source = "../../tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mock-tfplan-privateca-certificate-authority-empty-string-failure.sentinel"
  }
}



test {
  rules = {
    main = false
  }
}