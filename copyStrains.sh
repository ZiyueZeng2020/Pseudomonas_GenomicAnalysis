#!/usr/bin/env bash

for x in $(cat /mnt/shared/projects/niab/pseudomonas/ANI_9995_strains/SelectedClusterStrains.txt); do 
cp /mnt/shared/scratch/jconnell/pseudomonasProject/Ps_genomes_2795/ncbi_dataset/data/${x}/* /mnt/shared/scratch/zzeng/pseudomonas_genomes/ANIref892; 
done
