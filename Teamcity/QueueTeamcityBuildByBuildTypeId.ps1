param(
   [Parameter(Mandatory=$true)]
   [string]$buildTypeId)

function QueueTeamcityBuildByBuildTypeId
{
    param(
	   [Parameter(Mandatory=$true)]
	   [string]$buildTypeId)

#MAKE SURE THESE ARE SET BEFORE YOU RUN THE SCRIPT
#Retrieving system variables 
$teamcityHostUrl = [environment]::GetEnvironmentVariable("TEAMCITY_HOSTNAME","Machine")
$username = [environment]::GetEnvironmentVariable("TEAMCITY_USERNAME","Machine") 
$password = [environment]::GetEnvironmentVariable("TEAMCITY_PASSWORD","Machine") 

if ([string]::IsNullOrEmpty($teamcityHostUrl)) 
	{throw "Please set TEAMCITY_HOSTNAME in system variables"} 

if ([string]::IsNullOrEmpty($username)) 
	{throw "Please set TEAMCITY_USERNAME in system variables"} 

if ([string]::IsNullOrEmpty($password)) 
	{throw "Please set TEAMCITY_PASSWORD in system variables"} 

$baseUrl = "http://" + $teamcityHostUrl + "/httpAuth/action.html?"
$params = "add2Queue=" + $buildTypeId
$url = $baseUrl + $params

$uri = New-Object System.Uri ($url)  
$encoded =  [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($username+":"+$password ))  
$headers = @{Authorization = "Basic "+$encoded}  

Write-Host "Starting build for" $buildTypeId
Invoke-WebRequest -Uri $uri.AbsoluteUri -Headers $headers 

}

QueueTeamcityBuildByBuildTypeId -buildTypeId $buildTypeId