# Hands-on-with-Hashicorp-Sentinel

In this lab session, you will write and test policies that restrict resources, data sources, and modules provisioned by Terraform in AWS, Azure, and GCP. This lab uses the v2 versions of the tfplan, tfstate, and tfconfig Sentinel imports.

## Sentinel CLI installation for Linux 

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
