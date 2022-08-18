#!/bin/bash

# Exit immediately if any command fails
set -e

echo "Starting..."
sleep 1
# Create path to the "output.json" file
Path=$(echo "$1" | sed -e 's/.txt/.json/g')

# Create json variables
testName=$(< "$1" head -n +1 | cut -d "[" -f2 | cut -d "]" -f1 | xargs)  # Cutting the testname from output.txt
tests=$(< "$1" tail -n +3 | head -n -2)                                  # Data about each test from output.txt
results=$(< "$1" tail -n1)                                               # Summary results of tests from output.txt
json=$(jq -n --arg tn "$testName" '{testName:$tn,tests:[],summary:{}}')  # Create json structure

# Parse the data in tests
IFS=$'\n'                                                               # Delimiter new line
for i in $tests
do
    if [[ $i == not* ]]                                                 # Find the "not ok" status
    then
	    status=false
    else
	    status=true
    fi

    if [[ $i =~ expecting(.+?)[0-9] ]]               # Find the matching "... expecting ... 0-9" and put this expression in BASH_REMATCH[0]
    then
	    var1=${BASH_REMATCH[0]}                      # variables with expression above
	    name=${var1%,*}                              # variables with expression above without any symbol after "," from the tail
    fi
    
    if [[ $i =~ [0-9]*ms ]]                          # Find the matching "... 0-9ms" and put this expression in BASH_REMATCH[0]
    then
	    test_dur=${BASH_REMATCH[0]}                  # variables with expression above
    fi
# Add data to json structure
    json=$(echo "$json" | jq \
	    --arg name "$name" \
	    --arg status "$status" \
	    --arg duration "$test_dur" \
	    '.tests += [{name:$name,status:$status|test("true"),duration:$duration}]')
done

# Parse the data in results
IFS=$'\n'                                                          # Delimiter new line
for l in $results
do
    if [[ $l =~ [0-9]+ ]]                                          # Find the number with success tests
    then
	    success=${BASH_REMATCH[0]}                                 # variable with expression above
    fi

     if [[ $l =~ ,.[0-9]+ ]]                                       # Find the expression with failed tests
    then
	    var2=${BASH_REMATCH[0]}                                    # variable with expression above
	    failed=${var2:2}                                           # take only the number without anything else
    fi
    
    if [[ $l =~ [0-9]+.[0-9]+% ]] || [[ $l =~ [0-9]+% ]]           # Find the expression with integer or float percent rating
    then
	    var3=${BASH_REMATCH[0]}                                    # variable with expression above
	    rating=${var3%%%}                                          # variable without "%"
    fi

    if [[ $l =~ [0-9]*ms ]]                                        # Find the expression with the time duration
    then
	    duration=${BASH_REMATCH[0]}                                # variable with expression above
    fi
# Add data to json structure
json=$(echo "$json" | jq \
                --arg success "$success" \
                --arg failed "$failed" \
                --arg rating "$rating" \
	        --arg duration_r "$duration" \
	        '.summary += {success:$success|tonumber,failed:$failed|tonumber,rating:$rating|tonumber,duration:$duration_r}')
done
# Adding our json structure to output json file
echo "$json" | jq "." > "$Path"
echo "The work is already done succesfully"
