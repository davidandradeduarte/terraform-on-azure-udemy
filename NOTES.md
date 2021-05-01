# Course notes

- Terraform's configuration syntax is called HCL (HashiCorp Configuration Language)
- Declaring a variable:
    ```terraform
    variable "myvar" {
        type = string
        default = "hello terraform"
    }
    ```
- Using a variable:
    ```terraform
    var.myvar
    ```
- String interpolation:
    ```terraform
    "Something ${var.myvar} something"
    ```
- Declaring a map:
    ```terraform
    variable "mymap" {
        type = map(string)
        default = {
            "mykey1" = "my value 1"
            "mykey2" = "my value 2"
        }
    }
    ```
- Using a map:
    ```terraform
    var.mymap["mykey1"]
    ```
- Declaring a list:
    ```terraform
    variable "mylist" {
        type = list # if you omit the type it will try to infer it
        default = [1,2,3]
    }
    ```
- Using a list:
    ```terraform
    var.mylist[0]
    ```
- There's a set of default functions that Terraform provide, like `element`, `slice`, etc. Documentation: [https://www.terraform.io/docs/language/functions/index.html](https://www.terraform.io/docs/language/functions/index.html)
- When using resources we need to define the provider for those resources. Whether that be AWS, Azure, GCP, or any other supported providers.
- Example for creating an aws resource:
    ```terraform
    provider "aws" {}
    resource "aws_instance" "example" {
        ami = var.AWS_REGION
        instance_type = "t2.micro"
    }
    ```
- We can use a `*.tfvars` file to manage variable default values
- Resource's reference name must be unique
- `*.tfstate` saves the state of created resources. It will be updated if you make manual changes in the cloud provider's UI and once you run `terraform plan`
- `*.tfstate` files are usually saved on a cloud storage
- We can find terraform providers and core modules in [https://registry.terraform.io/](https://registry.terraform.io/)
- Terraform versioning uses SemVer
- Patch versions will only contain bug fixes
- Terraform deliver new features when they release minors and usually introduce breaking changes
- There's no major versions yet
- We can use aliases with providers to have more than one provider of the same type:
    ```terraform
    provider "azurerm" {

    }

    provider "azurerm" {
        alias = "myalias"
    }

    # usage
    azurerm # will default to provider without alias
    azurerm.myalias # will default to provider with alias= "myalias"
    ```
- `terraform fmt` formats terraform code
- `terraform taint` marks the resource to be destroyed and created (recreated) in the next `terraform apply`
- `terraform import` imports resources that were manually created. We must create the terraform code of this resource first and only then run the import command
- `terraform state` manipulate terraform state file
- `terraform workspace` create or change workspace
- terraform starts with a sinle workspace `default`. We can create a new workspace `terraform workspace new <workspace-name>`
- When creating a new workspace we start with an empty terraform state
- `terraform workspace select <workspace-name>` to switch between workspaces
- We can use the variable `${terraform.workspace}` to avoid naming colisions between workspaces
    ```terraform
    resoure "azurerem_virtual_machine" "myvm" {
        name = "/myapp/myname-${terraform.workspace}"
        ...
    }
    ```
- Even though a workspace gives you an "empty state", we're still using the **same state**, the **same backend configuration** (workspaces are technically equivalent of renaming the state file)
- For isolating environments we usually separate them by using different subscdiptions with different backends, stored in different state files
- `TF_LOG=DEBUG` (env var) will enable debug loggin on terraform. If we just want to enable it JIT use `TF_LOG=DEBUG terraform <command >`
- Valid log levels are: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`


# Additional notes

- I was hoping for a better introduction, specially regarding Terraform documentation. Where to find it, how to use it, etc. We jumped right into declaring/using variables and using the terraform console
- From what I understood Terraform code is not sequential, meaning that Terraform will undestand which blocks of code will read first (need to confirm this though) #TODO
- Virtual machine provisioning is becoming less frequent nowadays because the heavy use of containers and orchestrators