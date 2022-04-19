module "tfplan-functions" {
  source = "../../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

mock "tfrun" {
  module {
    source = "mock-tfrun-fail-suffix.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}