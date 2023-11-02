#!/usr/bin/env bash

#Realpath of this file: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/copyStrains.sh


for x in $(cat /mnt/shared/projects/niab/pseudomonas/ANI_9995_strains/SelectedClusterStrains.txt); do 
	#Print the path of the files to check Functional:)
	# genome=/mnt/shared/scratch/jconnell/pseudomonasProject/Ps_genomes_2795/ncbi_dataset/data/${x}/*
	# echo ${x}
	#The other way to print the path, no need to define:
	#ls genome=/mnt/shared/scratch/jconnell/pseudomonasProject/Ps_genomes_2795/ncbi_dataset/data/${x}/*
	cp /mnt/shared/scratch/jconnell/pseudomonasProject/Ps_genomes_2795/ncbi_dataset/data/${x}/* /mnt/shared/scratch/zzeng/pseudomonas_genomes/ANIref892; 

done

