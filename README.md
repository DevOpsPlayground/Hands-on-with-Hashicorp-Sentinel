# Hands-on-with-Hashicorp-Sentinel

In this lab session, you will write and test policies that restrict resources, data sources, and modules provisioned by Terraform in AWS. This lab uses the v2 versions of the tfplan, tfstate, and tfconfig Sentinel imports.

## Sentinel CLI installation for Linux (Not required for this lab)

Insatall unzip
```Bash
sudo apt install unzip
```

Create sentinel directory for the binary file
```Bash
mkdir ~/sentinel
```

Add sentinel directory to PATH by adding the below into the `.bashrc` file
```Bash
echo -e '\n# adding sentinel directory to PATH' >> ~/.bashrc;echo 'export PATH="$HOME/sentinel:$PATH"' >> ~/.bashrc
```

Load the new $PATH into the current session
```Bash
source ~/.bashrc
```

Download sentinel binary and unzip into the sentinel directory
```Bash
wget https://releases.hashicorp.com/sentinel/0.18.9/sentinel_0.18.9_linux_amd64.zip; unzip sentinel_0.18.9_linux_amd64.zip -d ~/sentinel;
```
Verifying the Installation by executing `sentinel`, you should see help output similar to the following:
```Bash
playground@playground:~$ sentinel
Usage: sentinel [--version] [--help] <command> [<args>]

Available commands are:
    apply      Execute a policy and output the result
    fmt        Format Sentinel policy to a canonical format
    test       Test policies
    version    Prints the Sentinel runtime version
```

Clean up
```Bash
rm sentinel_0.18.9_linux_amd64.zip
```

For more information, visit the official [Hashicorp Installation Guide](https://docs.hashicorp.com/sentinel/intro/getting-started/install)

<br>

## Become Familiar with all Sentinel Documentation
- [Main Sentinel docs](https://docs.hashicorp.com/sentinel)
- [Terraform Enterprise docs](https://www.terraform.io/cloud-docs/sentinel)
- [Learn Platform](https://learn.hashicorp.com/terraform?track=sentinel#sentinel)

<br>

## Exercise 1 - require-access-keys-use-pgp.sentinel

Your task in this exercise is to complete and test a Sentinel policy that requires that all AWS IAM access keys provisioned by Terraform's AWS Provider include a PGP key that starts with "keybase:".

Test Cases can be found in `test\require-access-keys-use-pgp`

Replace `<resource_type>` with the below
```
aws_iam_access_key
```

Replace `<attribute>` with the below
```
pgp_key
```

Replace `<condition>` with the below
```
violations is 0
```

Now test your policy
```
sentinel test require-access-keys-use-pgp.sentinel
```

## Exercise 2 - restrict-ec2-instance-type.sentinel

Your task in this exercise is to complete and test a Sentinel policy that requires that all EC2 instances have instance types from an allowed list.

Test Cases can be found in `test\restrict-ec2-instance-type`

Replace `<list_of_allowed_types>` with the below
```
"t2.small", "t2.medium", "t2.large"
```

Replace `<resource_type>` with the below
```
aws_instance
```

Replace `<attribute>` with the below
```
instance_type
```

Now test your policy
```
sentinel test restrict-ec2-instance-type.sentinel
```

## Exercise 3 - require-modules-from-pmr.sentinel

This policy ensures that all modules loaded directly by the root module are in the Private Module Registry (PMR) of a TFC organization. Your task is to make sure the test cases `pass` & `fail` pass.

Test Cases can be found in `test\require-modules-from-pmr`

First run the test command
```
sentinel test require-modules-from-pmr.sentinel
```

You should see something like the below
```
walesalami@M7XMTGVH0J Sentinel-Policies % sentinel test require-modules-from-pmr.sentinel
FAIL - require-modules-from-pmr.sentinel
  ERROR - test/require-modules-from-pmr/fail.hcl
    Error: require-modules-from-pmr.sentinel:7:30: Import "module-functions" is not available

    trace:
      no rules evaluated
  PASS - test/require-modules-from-pmr/pass.hcl
```

We are missing the test case for `fail`. Open the `fail.hcl` that is in the `test -> require-modules-from-pmr` directory and paste the below
```
module "module-functions" {
  source = "../../common-functions/module-functions/module-functions.sentinel"
}

param "organization" {
  value = "wale-play-ground"
}

mock "tfconfig/v2" {
  module {
    source = "mock-tfconfig-fail.sentinel"
  }
}

test {
  rules = {
    main = false
  }
}
```

Now run the test command again
```
sentinel test require-modules-from-pmr.sentinel
```

## Exercise 4 - enforce-mandetory-resource-tags.sentinel

Your task in this exercise is to complete and test a Sentinel policy that specified AWS resources have all mandatory tags.

Test Cases can be found in `test\enforce-mandetory-resource-tags`

Replace `<resource_types>` with the below
```
  "aws_s3_bucket",
  "aws_instance",
  "aws_vpc",
  "aws_iam_role",
```

Replace `<mandatory_tags>` with the below
```
"Owner", "Purpose"
```

Replace `<custom_function>` with the below
```
find_resources_with_standard_tags = func(resource_types) {
  resources = filter tfplan.resource_changes as address, rc {
    rc.provider_name matches "(.*)aws$" and
    rc.type in resource_types and
  	rc.mode is "managed" and
    (rc.change.actions contains "create" or rc.change.actions contains "update" or
     rc.change.actions contains "read" or rc.change.actions contains "no-op")
  }

  return resources
}
```

Replace `<attribute>` with the below
```
tags
```

Replace `<main_rule>` with the below
```
main = rule {
  length(violatingAWSResources["messages"]) is 0
}
```

Now test your policy
```
sentinel test enforce-mandetory-resource-tags.sentinel
```

## Bonus - prevent-auto-apply-in-production.sentinel

Your task in this exercise is to complete and test a Sentinel policy that prevents any workspace with a name starting with "prod-" or ending in "-prod" from having the Auto Apply property set to "true".
This policy uses the tfrun import.

Test Cases can be found in `test\enforce-mandetory-resource-tags`

<br />

<details>
<summary>Click here for the solution!</summary>

```
validate_auto_apply = func() {

  validated = true

  if tfrun.workspace.name matches "^prod-(.*)" or
     tfrun.workspace.name matches "(.*)-prod$" {
  # if strings.has_prefix(tfrun.workspace.name, "prod-") or
  #   strings.has_suffix(tfrun.workspace.name, "-prod") {
    if tfrun.workspace.auto_apply is true {
      print("The workspace", tfrun.workspace.name, "has auto_apply set to true")
      validated = false
    }
  }

  return validated
}
```
</details>
<br />

Test your policy with the below
```
sentinel test prevent-auto-apply-in-production.sentinel
```

## Test the entire policy set

```
sentinel test
```

