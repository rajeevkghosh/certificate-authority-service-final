module "tfplan-functions" {
  source = "../../../../common-functions/tfplan-functions/tfplan-functions.sentinel"
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