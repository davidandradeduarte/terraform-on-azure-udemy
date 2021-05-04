# First steps

## Finding images
```
az vm image list -p "Canonical"
az vm image list -p "Microsoft"
```

## Generating SSH key
```bash
ssh-keygen -f mykey
```

## Run the infrastructure

```bash
terraform init
terraform plan
terraform apply
# login to vm
ssh <public-ip> -i mykey -l demo
```

## Destroy the infrastructure

```bash
terraform destroy
```