# Script1

# Define the mandatory params
param ( [Parameter(Mandatory)]$ip_address_1,
        [Parameter(Mandatory)] $ip_address_2,
        [Parameter(Mandatory)] $network_mask
    )
# Check the correct entered ip adresses xxx.xxx.xxx.xxx format
if ( ($ip_address_1 -as [IPAddress]) -and ($ip_address_2 -as [IPAddress]) ){
}
else{
    "Sorry you entered the wrong ip adresses"
Exit
}
# Check the correct entered network mask in xxx.xxx.xxx.xxx or xx format
if ($network_mask -match '^(255|254|252|248|240|224|192|128|0)\.(255|254|252|248|240|224|192|128|0)\.(255|254|252|248|240|224|192|128|0)\.(255|254|252|248|240|224|192|128|0)$' -or ($network_mask -match '^([0-3]?[0-9]$)' -and $network_mask -le 32) )
 {
    if ($network_mask -match '^([0-3]?[0-9]$)' -and $network_mask -le 32) {
        function ConvertTo-IPv4MaskString {                                                         # Define the function to convert mask from xx to xxx.xxxx.xxx.xxx
            <#
            Convert value of network mask xx to xxx.xxx.xxx.xxx
            #>
            param(
                  [Int] $Mask_bits
            )
            $mask = ([Math]::Pow(2, $Mask_bits) - 1) * [Math]::Pow(2, (32 - $Mask_bits))            # Convert XX to bits value
            $bytes = [BitConverter]::GetBytes([UInt32] $mask)                                       # Convert bits to byte value
            (($bytes.Count - 1).. 0 | ForEach-Object { [String] $bytes[$_] }) -join "."             # Gather in xxx.xxx.xxx.xxx format from end to begin
          }
            $network_mask = ConvertTo-IPv4MaskString $network_mask                                  # Redefine var "network_mask" if the function has worked
        }
    }
    else {
        "Sorry you entered the wrong network mask"
        Exit
}
# Check the ip adresses and network mask for belong to common net
$ip1 = [ipaddress] $ip_address_1                                                # Create class ipaddress for ip adresses and network mask 
$ip2 = [ipaddress] $ip_address_2                                                
$subnet = [ipaddress] $network_mask
$network_1 = [ipaddress] ($ip1.Address -band $subnet.Address)                   # Create class ipaddress after bitwise AND with subnet 
$network_2 = [ipaddress] ($ip2.Address -band $subnet.Address)                   
if ( $network_1.Address -eq $network_2.Address )                                # Check the equals
{
    Write-Host "Yes"
}
else 
{
    Write-Host "No"
}
