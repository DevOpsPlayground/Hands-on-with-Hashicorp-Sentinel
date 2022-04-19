module "tfplan-functions" {
  source = "../../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "mock-tfplan-fail-c4-8xlarge.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}