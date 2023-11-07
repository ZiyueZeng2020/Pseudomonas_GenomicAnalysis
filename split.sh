#!/usr/bin/env bash

awk 'BEGIN {OFS="\t"} {
    # Insert an empty column after column 7
    for (i = NF; i > 7; i--) {
        $i = $(i-1);
    }

    # Split the second field by underscores
    split($2, a, "_");

    
    # Assign the values to the respective fields
    $8 = a[3];
    $2 = a[1] "_" a[2];

    # Print the modified line
    print
}'  /mnt/shared/scratch/zzeng/results_JC/SI1679.txt > SI1679_copy1.txt


awk 'BEGIN {OFS="\t"} {
    # Split the 6th field by underscores
    split($6, a, "_");

    # Insert an empty column after column 8
    for (i = NF; i > 8; i--) {
        $i = $(i-1);
    }

    # Assign the values to the respective fields
    $9 = a[3] "_" a[4];
    $6 = a[1] "_" a[2];

    # Print the modified line
    print
}'  /mnt/shared/scratch/zzeng/results_JC/SI1679_copy1.txt > SI1679_copy2.txt
