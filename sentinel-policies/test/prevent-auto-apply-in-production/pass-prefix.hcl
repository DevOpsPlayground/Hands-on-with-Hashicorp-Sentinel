module "tfplan-functions" {
  source = "../../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

mock "tfrun" {
  module {
    source = "mock-tfrun-pass-prefix.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}