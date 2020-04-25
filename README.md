# getPowerBiActivitiesLog
Power Shell script to get Power Bi activities logs within a days range

The script is called getPowerBiActivities.ps1. It receives 2 parameters:
1.	$daysCount   - last days count for which you want to get logs
2.	$filesDirectory  - directory where you want to save csv logs files

Execute script with the next command: 

getPowerBiActivities.ps1 -daysCount 30 -filesDirectory D:\work\reports


This script will automatically execute Login-PowerBi, Get-PowerBIActivityEvent and Export-Csv commands and save 30 .csv files for every date in this range to D:\work\reports directory, even if this directory does not exist. 
