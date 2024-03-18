#!/usr/bin/env bash
#SBATCH -J DownGenome
#SBATCH -p short
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4

###Realpath: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/DownloadSequence.sh
source activate ncbi_datasets 

for x in $(cat /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/GenbankPs/PathogenRef_Add); do
	cd /mnt/shared/scratch/zzeng/pseudomonas_genomes/pathogens
	datasets download genome accession ${x}
	unzip *.zip 
	cp ncbi_dataset/data/${x}/*.fna ./
	rm -r *.zip README.md ncbi_dataset
done 

conda deactivate 
