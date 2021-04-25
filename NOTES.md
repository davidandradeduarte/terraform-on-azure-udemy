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
- 

# Additional notes

- I was hoping for a better introduction, specially regarding Terraform documentation. Where to find it, how to use it, etc. We jumped right into declaring/using variables and using the terraform console.