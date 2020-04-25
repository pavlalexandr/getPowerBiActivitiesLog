[CmdletBinding()]
param (
    [Parameter()]
    [uint32]
    $daysCount,
    [Parameter()]
    [string]
    $filesDirectory
)

function Use-Module ($m) {

    # If module is imported say that and do nothing
    if (Get-Module | Where-Object {$_.Name -eq $m}) {
        write-host "Module $m is already imported."
    }
    else {

        # If module is not imported, but available on disk then import
        if (Get-Module -ListAvailable | Where-Object {$_.Name -eq $m}) {
            Import-Module $m -Verbose
        }
        else {

            # If module is not imported, not available on disk, but is in online gallery then install and import
            if (Find-Module -Name $m | Where-Object {$_.Name -eq $m}) {
                Install-Module -Name $m -Force -Verbose -Scope CurrentUser
                Import-Module $m -Verbose
            }
            else {

                # If module is not imported, not available and not in online gallery then abort
                write-host "Module $m not imported, not available and not in online gallery, exiting."
                EXIT 1
            }
        }
    }
}

#install module if not exists
Use-Module("MicrosoftPowerBIMgmt")

#login to power bi account
Login-PowerBI

function createIfNotExists($directory)
{
    if(![system.io.directory]::Exists($directory)) 
    {
        [system.io.directory]::CreateDirectory($directory)
    }
}
#if filesPath empty then set the same output directory where script located
if(!$filesDirectory)
{
$filesDirectory = "./"
}
else {
    createIfNotExists($filesDirectory)
}
for($i=0;$i -lt $daysCount;$i++)
{

$activitiesDate = [System.DateTime]::Now.Date.AddDays(-$i)
$dateTimeStart = $activitiesDate.Date.ToString("s")
$dateTimeEnd =  $activitiesDate.Date.AddHours(23).AddMinutes(59).AddSeconds(59).ToString("s")



$fileName = $filesDirectory+$activitiesDate.Date.ToString("dd-MM-yyyy")+".csv"
#ConvertFrom-Json |
$activities = Get-PowerBIActivityEvent -StartDateTime $dateTimeStart -EndDateTime: $dateTimeEnd | ConvertFrom-Json
$psObjectForCsv = $activities | ForEach-Object {
    [PSCustomObject]@{
        "id"=$_.Id
        "RecordType" = $_.RecordType
        "CreationTime" = $_.CreationTime
        "Operation" = $_.Operation
        "OrganizationId" = $_.OrganizationId
        "UserType" = $_.UserType
        "UserKey" = $_.UserKey
        "Workload"=$_.Workload
        "UserId"=$_.UserId
        "ClientIP"=$_.ClientIP
        "UserAgent"=$_.UserAgent
        "Activity"=$_.Activity
        "ItemName"=$_.ItemName
        "WorkSpaceName"=$_.WorkSpaceName
        "DatasetName"=$_.DatasetName
        "ReportName"=$_.ReportName
        "WorkspaceId"=$_.WorkspaceId
        "ObjectId"=$_.ObjectId
        "DatasetId"=$_.DatasetId
        "ReportId"=$_.ReportId
        "EmbedTokenId"=$_.EmbedTokenId
        "IsSuccess"=$_.IsSuccess
        "ReportType"=$_.ReportType
        "RequestId"=$_.RequestId
        "ActivityId"=$_.ActivityId
        "DistributionMethod"=$_.DistributionMethod
        "ConsumptionMethod"=$_.ConsumptionMethod
    }
}
$psObjectForCsv | Export-Csv -path $fileName -Force
}

