module "tfplan-functions" {
    source = "./common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "./common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "module-functions" {
    source = "./common-functions/module-functions/module-functions.sentinel"
}

policy "require-access-keys-use-pgp" {
    enforcement_level = "hard-mandatory"
}

policy "enforce-mandetory-resource-tags" {
    enforcement_level = "hard-mandatory"
}

policy "restrict-ec2-instance-type" {
    enforcement_level = "hard-mandatory"
}

policy "prevent-auto-apply-in-production" {
    enforcement_level = "hard-mandatory"
}