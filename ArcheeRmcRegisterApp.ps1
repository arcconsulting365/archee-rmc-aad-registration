param ([Parameter(Mandatory=$true)]$RedirectUri , [Parameter(Mandatory=$true)]$TenantId, $AppName = "Archee RMC")
$connectionInfo = Connect-AzureAD -TenantId $TenantId

$reqResAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
$reqResAccess.ResourceAccess = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" -ArgumentList "e1fe6dd8-ba31-4d61-89e7-88639da4683d","Scope"
$reqResAccess.ResourceAppId = "00000003-0000-0000-c000-000000000000"

$aadApp = New-AzureADApplication -DisplayName $appName -Oauth2AllowImplicitFlow $true -AvailableToOtherTenants $false -ReplyUrls $RedirectUri -RequiredResourceAccess $reqResAccess
$secret = New-AzureADApplicationPasswordCredential -ObjectId $aadApp.ObjectId -CustomKeyIdentifier "ClientSecret" -EndDate (Get-Date).AddYears(900)

Write-Output "{ `"clientId`": `"$($aadApp.AppId)`", `"clientSecret`": `"$($secret.Value)`", `"userLogin`": `"$($connectionInfo.Account.Id)`" }"