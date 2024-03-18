#!/bin/bash

# Define an array
#my_array=("element1" "element2" "element3")

# Iterate over all elements in the array
#for element in "${my_array[@]}"; do
#    echo "$element"
#done

# Define an array
my_array=("element1" "element2" "element3")

# Without [@], only the first element is referenced
echo "Without [@]: $my_array"

