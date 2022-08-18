# Script2
Write-Host "Starting...."
Start-Sleep 1
# Create path to the "_new.csv" file
$Path = $args[0] -replace 'accounts.csv', 'accounts_new.csv'
# Convert .csv file into array and fill it data with pattern
$array = Import-CSV $args[0]
# Define the start variables
$i = 0                          # Start number
$sum = $array.Count             # Finish number
$export = @()                   # Define export array
# Do some transformation and fill the array with data
while ($i -lt $sum)
 {
    $Name = ($array.name[$i].Split("") | ForEach-Object {$_.Substring(0,1).toUpper() + $_.Substring(1).toLower()}) -join '' + ' '    # Do name like pattern name
    $var1 = $array.name[$i].Split("") | ForEach-Object {$_.Substring(0).toLower()}                                                   # Do lower name and surname
    $Email = $var1[0].Chars(0) + $var1[1] + $array.location_id[$i] + '@abc.com'                                                      # Gather email like pattern email
    $object = New-Object psobject
    $object | Add-Member -MemberType NoteProperty -Name "id" -value $array.id[$i]                                                    # Create array with headers
    $object | Add-Member -MemberType NoteProperty -Name "location_id" -value $array.location_id[$i]
    $object | Add-Member -MemberType NoteProperty -Name "name" -value $Name
    $object | Add-Member -MemberType NoteProperty -Name "title" -value $array.title[$i]
    $object | Add-Member -MemberType NoteProperty -Name "email" -value $Email
    $object | Add-Member -MemberType NoteProperty -Name "department" -value $array.department[$i]
    $i++
    $export += $object 
    }
$export | Export-csv $Path -encoding "UTF8" -NoTypeInformation                 # Export to .csv file 
if ($?) {
Write-Host "Everything is done"
}