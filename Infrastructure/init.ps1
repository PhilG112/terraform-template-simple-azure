[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupLocation,

	[Parameter(Mandatory=$true)]
    [string]$ResourceGroupName,

	[Parameter(Mandatory=$true)]
    [string]$AppServicePlanName,

	[Parameter(Mandatory=$true)]
    [string]$AppServiceName,  

    [Parameter(Mandatory=$true)]
    [string]$CosmosDbAccountName
)

if(!$PSScriptRoot){
    $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
}

$RootPath = $PSScriptRoot
$TerraformVariablesFile = Join-Path $RootPath "./variables.tf"

(Get-Content $TerraformVariablesFile).replace('[rg-name]', $ResourceGroupName) | Set-Content $TerraformVariablesFile
Write-Host "Set Resource Group Name to $ResourceGroupName"
(Get-Content $TerraformVariablesFile).replace('[rg-location]', $ResourceGroupLocation) | Set-Content $TerraformVariablesFile
Write-Host "Set Resource Group Location to $ResourceGroupLocation"
(Get-Content $TerraformVariablesFile).replace('[app-service-plan-name]', $AppServicePlanName) | Set-Content $TerraformVariablesFile
Write-Host "Set App Service Plan name to $AppServicePlanName"
(Get-Content $TerraformVariablesFile).replace('[app-service-name]', $AppServiceName) | Set-Content $TerraformVariablesFile
Write-Host "Set App Service Name to $AppServiceName"
(Get-Content $TerraformVariablesFile).replace('[cosmosdb-acc-name]', $CosmosDbAccountName) | Set-Content $TerraformVariablesFile
Write-Host "Set CosmosDB Account Name to $CosmosDbAccountName"

Write-Host "Initalizing terraform based on provide..."
terraform init

Write-Host "Validating terraform template..."
terraform validate -check-variables=true

Write-Host "Applying terraform template..."
terraform apply