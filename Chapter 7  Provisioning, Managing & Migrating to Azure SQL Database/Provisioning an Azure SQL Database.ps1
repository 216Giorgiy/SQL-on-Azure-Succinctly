Import-Module Azure
Add-AzureAccount

#Select the desired Azure Subscription
[array] $AllSubs = Get-AzureSubscription 
If ($AllSubs)
{
        Write-Host "`tSuccess"
}
Else
{
        Write-Host "`tNo subscriptions found. Exiting." -ForegroundColor Red
        Exit
}
#Write-Host "`n[Select Option] - Select a Subscription to Work With" -ForegroundColor Yellow
$count = 1
ForEach ($Sub in $AllSubs)
{
   $SubName = $Sub.SubscriptionName
   Write-host "`n$count - $SubName"  -ForegroundColor Green
   $count = $count+1
}
$SubscriptionNumber = Read-Host "`n[SELECTION] - Select a Subscription to Provision the VM"
If($SubscriptionNumber -gt $count)
{
    Write-Host "`Invalid Subscription Entry - Existing" -ForegroundColor Red
    Exit
}
$SelectedSub = Get-AzureSubscription -SubscriptionName $AllSubs[$SubscriptionNumber - 1].SubscriptionName 3>$null 
$SubName = $SelectedSub.SubscriptionName
Write-Host "`n Selected Subscription - $SubName" -ForegroundColor Green 
$SelectedSub | Select-AzureSubscription | out-Null

$Location = "South Central US"
$DatabaseName = "myazuresqldb"

$server = New-AzureSqlDatabaseServer  -Location $location –AdministratorLogin "mysqlsa" -AdministratorLoginPassword "Pa$$w0rd" -Version "12.0"

New-AzureSqlDatabase  -ServerName $server.ServerName -DatabaseName $DatabaseName -Edition "Basic" -MaxSizeGB 2
