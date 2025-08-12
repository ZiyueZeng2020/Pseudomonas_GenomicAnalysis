#!/bin/bash
#SBATCH -p short

# Define the file path containing the list and the directory path
listA="/home/zzeng/scratch/pseudomonas_genomes/strainName/Ref/NP_pathogens44"
directory_path="/mnt/shared/scratch/zzeng/pseudomonas_genomes/ANIref_uniq860"

# Read each line from the listA file
while IFS= read -r item; do
    found="no"
    # Iterate over files in the directory
    for filename in "$directory_path"/*; do
        # Check if the item is in the filename
        if [[ $(basename "$filename") == *"$item"* ]]; then
            found="yes"
            break
        fi
    done
    if [[ $found == "no" ]]; then
        echo "$item not found"
    else
        echo "$item found"
    fi
done < "$listA"
