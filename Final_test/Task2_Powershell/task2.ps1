# Script2
Write-Host "Starting...."
Start-Sleep 1
# Create path to the "_new.csv" file
$Path = $args[0] -replace 'accounts.csv', 'accounts_new.csv'
# Convert .csv file into array and fill it data with pattern
$array = Import-CSV $args[0]
# Define the start variables
$i = 0                          # Start number of cycle
$sum = $array.Count             # Finish number of cycle
$j = 0                          # Start number of cycle
$count = 0                      # Count's of repeated emails
$export = @()                   # Define export array
$emails = @()                   # Define array for checking equals email's
# Do array for emails to check on equals
while ($i -lt $sum)
{
    $Name = ($array.name[$i].Split(" ") | ForEach-Object {$_.Substring(0,1).toUpper() + $_.Substring(1).toLower()}) -join '' + ' '    # Do name like pattern name
    $var1 = $array.name[$i].Split(" ") | ForEach-Object {$_.Substring(0).toLower()}                                                   # Do lower name and surname
    $Email = $var1[0].Remove(1) + $var1[1]                                                                                            # email
  
    $object = New-Object psobject                                                                                                     # Create emails array and fill data
    $object | Add-Member -MemberType NoteProperty -Name "email" -value $Email
    $i++
    $emails += $object                                                                                                  
}
# Do final array to export in .csv
while ($j -lt $sum) {
    $Name = ($array.name[$j].Split(" ") | ForEach-Object {$_.Substring(0,1).toUpper() + $_.Substring(1).toLower()}) -join '' + ' '    # Do name like pattern name 
    $var1 = $array.name[$j].Split(" ") | ForEach-Object {$_.Substring(0).toLower()}                                                   # Do lower name and surname
    $count = ($emails | Where-Object { $_.Email -eq $emails.Email[$j] }).Count                                                        # Count the numbers of each email
    if ($count -gt 1) {                                                                                                                
        $Email = $var1[0].Remove(1) + $var1[1] + $array.location_id[$j] + '@abc.com'                                                  # Gather email like pattern
    }
    else {
        $Email = $var1[0].Remove(1) + $var1[1] + '@abc.com'
    }
    $object = New-Object psobject                                                                                                     # Create array to export with headers
    $object | Add-Member -MemberType NoteProperty -Name "id" -value $array.id[$j] 
    $object | Add-Member -MemberType NoteProperty -Name "location_id" -value $array.location_id[$j]
    $object | Add-Member -MemberType NoteProperty -Name "name" -value $Name
    $object | Add-Member -MemberType NoteProperty -Name "title" -value $array.title[$j]
    $object | Add-Member -MemberType NoteProperty -Name "email" -value $Email
    $object | Add-Member -MemberType NoteProperty -Name "department" -value $array.department[$j]
    $export += $object
$j++
}
$export | Export-csv $Path -encoding "UTF8" -NoTypeInformation                 # Export to .csv file 
if ($?) {
Write-Host "Everything is done"
}
