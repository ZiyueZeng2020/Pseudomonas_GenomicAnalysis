#!/usr/bin/env bash
#SBATCH -J runJob
#SBATCH -p short
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1

source activate ncbi_datasets 

for x in GCA_000007805.1 GCA_000412675.1 GCA_002905835.1 GCA_000012245.1 GCA_023278105.1 GCA_021609785.1​ GCA_021607085.1​ GCA_000005845.2; do
	cd /mnt/shared/scratch/zzeng/pseudomonas_genomes
	datasets download genome accession ${x}
	unzip *.zip 
	cp ncbi_dataset/data/${x}/*.fna ./
	rm -r *.zip README.md ncbi_dataset
done 

conda deactivate 
