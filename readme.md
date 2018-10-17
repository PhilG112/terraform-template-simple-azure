# Simple Terraform Azure Script

This is a simple Terraform script that will create the following on Azure:
- Azure Resource Group
- Azure App Service Plan
- Azure App Service
- CosmosDB Account

---

## Prerequisite

- Terraform added to system path

## How to use

**_Note you may need to run the command `az login` in the same directory as the `main.tf` file_**

1. Clone this repo
2. Run the `init.ps1` powershell script
3. Give names to the resources when prompted
4. The command `terraform init` will run
5. The command `terraform validate -check-variables=true` will run
6. Finally the command `terraform apply` will run