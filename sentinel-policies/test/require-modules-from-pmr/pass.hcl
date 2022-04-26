module "module-functions" {
  source = "../../common-functions/module-functions/module-functions.sentinel"
}

param "organization" {
  value = "wale-play-ground"
}

mock "tfconfig/v2" {
  module {
    source = "mock-tfconfig-pass.sentinel"
  }
}

test {
  rules = {
    main = true
  }
}