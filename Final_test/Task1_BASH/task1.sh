#!/bin/bash

# Exit immediatly if any command failed
set -e

echo "Starting..."
sleep 1
# Create path to the "_new.csv" file
Path=$(echo "$1" | sed -e 's/.csv/_new.csv/g')
i=0
# Convert .csv file into array and fill it with data with pattern
arr=()
while IFS=$',' read -r var1 var2 var3 var4 var5 var6; do
if [ $i -eq 0 ]; then
    arr+=("$var1, $var2, $var3, $var4, $var5, $var6")                           # Fill the head of the table
    i=1
    else                                                                        # Fill the data to the table
Name=$(echo "$var3" | sed 's/\b\([[:alpha:]]\)\([[:alpha:]]*\)\b/\u\1\L\2/g')   # Change the  first letter of Name and Surname to uppercase
var33=$(echo "$var3" | cut -c 1 | tr [:upper:] [:lower:])                       # Select only first letter of Name and get lowercase
var34=$(echo "$var3" | awk '{print $2}' | tr [:upper:] [:lower:])               # Take Surname and get lowercase
email="$var33$var34$var2@abc.com"                                               # Gather email address
arr+=("$var1, $var2, $Name, $var4, $email, $var6")
fi
done < "$1"
echo "${arr[@]}" > "$Path"                                                      # Output to the file "_new.csv"
echo "Everything is done"