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
- There's a set of default built-in functions that Terraform provide, like `element`, `slice`, etc. Documentation: [https://www.terraform.io/docs/language/functions/index.html](https://www.terraform.io/docs/language/functions/index.html)
- There's no support for user defined functions
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
- variable types are infered and not mandatory, but it's recommended to allways set variable types
- Terraform simple types: `string`, `number`, `bool`
- Terraform complex type: `list(type)`, `set(type)`, `map(type)`, `objetc({<attr name> = <type>, ...})`, `tuple([<type>, ...])`
- `terraform apply` will read all `*.tf` files and apply the terraform code to the cloud provider that we configured
- `terraform plan` will create an execution plan, without running the changes on the cloud provider
- `terraform init` is used to initialize a working directory containing Terraform configuration files. We also need to run it every time we add a new module or provider
- `terraform destroy` will remove all the infrastructure
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
- `terraform validate` validates syntax errors in terraform files
- `terraform force-unlock <id>` can be used to force unlock the state file, in case there's a lock but nobody is running a terraform apply
- `terraform refresh` will update the state file without applying
- terraform state file might contain secrets (e.g database admin password)
- 3 types of variables in terraform: `input`, `output` and `local`
- input:
    ```terraform
    variable "my-input" { ... }
    ```
- output:
    ```terraform
    output "my-output" { ... }
    ```
- local:
    ```terraform
    locals { 
        my-local = my-value
        ...
    }
    ```
- input variables can have the following optional arguments:
    1. default
    1. type
    1. description
    1. validation
    1. sensitive
- `any` is a generic type that accepts all value types
- Azure AD uses a different terraform provider: `azuread`
- We can create a remote state in terraform azure by creating a resource group with a storage account and a container, and associate it with the backend:
    ```terraform
    terraform {
        backend "azurerm" {
            resource_group_name  = "terraform-state"
            storage_account_name = "tfstoragetrainingdavid"
            container_name       = "terraform-state-container"
            key                  = "terraform.tfstate"
        }
    }
    ```
- **Conditionals** - basically ternary operations `condition ? true_val : false_val`
- We can override variables by providing `--var var_name=var_value` to the terraform CLI
- We can use `for` and `for_each` loops in Terraform
    ```terraform
        # for
        [for s in var.list : upper(s)]

        # for_each is a meta argument to be used inside a resource
        # it creates as many resources as the for_each list length
        for_each = var.list
    ```
- There's not good support within Terraform for Azure DevOps at this time


# Azure concepts

- **Resource Manager** - deployment and management service in Azure. It's the management layer to create, update and delete resources in the Azure subscription. AzureRM plugin uses the Azure SDK to connect to the Resource Manager. The resource manager provides authentication and authorization.
![Resource Manager](/img/resource-manager.png)
**Scopes**
    - **Management Groups** - Groups to manage your subscriptions
    - **Subscriptions** - Trials, Pay as you go, or Enterprise Agreements
    - **Resource Groups** - Container that holds your resources
    - **Resources** - VNets, VMs, Storage, ...
- A resource can only exist within a single Resource Group
- A resource from one Resource Group can still use a resource from another resource group if the permissions allow it
- Resources can me moved between resource groups
- Role Based Access Control (RBAC) can be applied on the resource group level, allowing you to provide access to users on a resource group level
- **Virtual Networks** or **VNet** provides you with a private network in Azure. It's the first resource we need to have before creating VMs and other services that need private network connectivity. We need to specify the location (region) and the address space (private IP range). E.g 192.168.0.0/16, 10.0.0.0/8, etc
- We can create subnets inside a VNet to logically separate resources on IP ranges
- When creating a subnet, Azure will reserve 5 IP addresses for own use:
    1. X.X.X.0 - Network address
    1. X.X.X.1 - Reserved by Azure for the default gateway
    1. X.X.X.2, X.X.X.3 - Reserved by Azure to map the Azure DNS IPs to the VNet space
    1. X.X.X.255 - Network broadcast address
- For each subnet Azure will create a default route table to ensure that IP addresses can be routed to other subnets, virtual networks, VPN or the internet. We can override the default routes by creating our own custom routes
- **Azure Virtual Machines** - we can search for available images in the marketplace or `az list vm`. There's a lot of properties we need to set, like profile, storage, network, resource group, etc. I wont go into more detail on VM's. First their use is becoming less and less common now a days. Second when you need to create a VM, we usually just read throught the documentation and provide each necessary property
- **Network Security Groups & Appliaction Security Groups** - can filter from/to Azure resources. They consist of security rules each with their own priority. We can set rules on source/destination IP/port ranges or service tags/application security groups, provide the IP protocol (TCP/UDP/ICMP/Any), the direction (incoming/outgoing) and action (allow/deny)
- **Inbound default rules:** By default there's a security rule to block all inbound connections to any protocol, ip, port. There are two exceptions by default: if the source is an Azure Virtual Network or an Azure Load Balancer
- **Outbound default rules:*** By default there's a security rule to allow all outbound internet connections. There's also a rule to allow all Virtual Network connections
- **Application Security Groups** can group virtual machines and multiple network interfaces. They're just a way of logically separating your virtual machines and can be handy when creating security groups and rules
![Application Security Groups](/img/application-security-groups.png)
- **Availability Zones** - protect applications and data from datacenter failures. Not all regions support availability zones, we can check here: [https://azure.microsoft.com/en-us/global-infrastructure/geographies/](https://azure.microsoft.com/en-us/global-infrastructure/geographies/)
- **(Auto)Scaling & Load Balancing** - scale sets can manually or automatically scale up or down a group of VMs. Horizontal scaling. Typically we put a Load Balancer in front of the VMs to handle the requests over the multiple VMs. Scale sets can save money because they scale up when demand is high and down when demand is low
- **Azure DevOps** provides CI/CD pipelines to build, test and deploy our applications
- We can push our built images to **Azure Container Registry**

# Azure Services

- **Azure Database for MySQL** - managed mysql database with automatic patching, backups, built-in monitoring and SSL connections. High availability. Every traffic is routed through an **Azure Gateway** to the MySQL server(s)
- **Azure SQL Database** - managed relational database with automatic upgrading, patching, backups and monitoring. It provides geo-replication, point-in-time restores, auto-failover groups and zone-redundant databases. It's a fork of SQL Server on the cloud as a managed service
- **Cosmos DB** - globally distributed, multi-model database service. Relational, NoSQL, Graphs. Elastic scale. Very fast. Supports multiple APIs - SQL, MongoDB, Cassandra, Gremlin, Table
- **Azure Storage** - virtually limitless, pay-as-you-go, multiple programming language clients. It provides durability, high availability, scalability, security and accessibility. The current different storage types are:
    - BLOB Storage - unstructured data and files
    - Table Storage - NoSQL data, schemaless
    - File Storage - fully managed file share
    - Queue Storage - message storage queue
    - Data Lake Gen2 - big data analysis
    - Disk Storage - virtual hard disks, encryption, disk roles, snapshots
- **Azure Active Directory** - Cloud based identity and access management. Works for external and internal access
- **Azure AD Connect** - tool for connecting on premisses identity infrastructure to microsoft's Azure Active Directory
- Azure AD works for *B2C* AND *B2B*
- **User/Service Principal** - security principal defines the access policy and permissions for the user/application in the Azure AD tenant
- **Application Gateway** - web traffic load balancer. Operates on the OSI layer 7 (application). SSL/TLS termination. Request based routing. Web application firewall. Can be used as a Kubernetes Ingress Controller
- **Azure Stream Analytics** - Real time analytics and complex event processing engine. Sensors, clickstreams, social media feeds, applications, etc. SAQL (Stream Analytics Query Language) SQL like query. Serverless, scaled and fully managed. Can ingest data and forward it to databases, event hubs, azure functions, power BI, processors, etc
![Azure Stream Analytics](/img/azure-stream-analytics.png)
- **AKS** - Azure Kubernetes Service is Azure's fully managed Kubernetes offering which integrates with all the other Azure services

# Additional notes

- I was hoping for a better introduction, specially regarding Terraform documentation. Where to find it, how to use it, etc. We jumped right into declaring/using variables and using the terraform console (edit: this came much later in the course)
- From what I understood Terraform code is not sequential, meaning that Terraform will undestand which blocks of code will read first (need to confirm this though) #TODO
- Virtual machine provisioning is becoming less frequent nowadays because the heavy use of containers and orchestrators
