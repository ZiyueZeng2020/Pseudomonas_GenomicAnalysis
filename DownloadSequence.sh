#!/usr/bin/env bash
#SBATCH -J DownGenome
#SBATCH -p short
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4

###Realpath: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/DownloadSequence.sh

### Ensure the script stops on any error. Exit if theres an error ###
set -e 

GCA_LIST="/mnt/shared/scratch/zzeng/NameList/Ref39"
GENOME_DIR="/mnt/shared/scratch/zzeng/genomes/ref/ref39"

mkdir -p "$GENOME_DIR"
cd "$GENOME_DIR"

###--- Full GCA code ---###
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/ncbi_datasets

while read -r x; do
  echo "Downloading genome: $x"
  datasets download genome accession ${x}
  unzip -oq *.zip
  cp ncbi_dataset/data/${x}/*.fna ./
  rm -r *.zip README.md ncbi_dataset

done < "$GCA_LIST"

conda deactivate
echo "Download completed for all genomes!"

#############################################################################################################
###--- Single GCA code --- ###
# source activate ncbi_datasets 
# 	cd /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref/Test
# 	datasets download genome accession GCF_000012205
# 	unzip *.zip 
# 	cp ncbi_dataset/data/GCF_000012205/*.fna ./
# 	rm -r *.zip README.md ncbi_dataset
# conda deactivate 
#############################################################################################################
###--- Partial GCA code ---###
# source activate ncbi_datasets 
# 
# for x in $(cat sbatch /home/zzeng/scratch/NameList/PG2dRef); do
# 	cd /mnt/shared/scratch/zzeng/ref_PG2d
# 	datasets download genome accession ${x}
# 	unzip *.zip 
# 	cp ncbi_dataset/data/${x}.*/*.fna ./
# 	rm -r *.zip README.md ncbi_dataset
# done 
# 
# conda deactivate 

#############################################################################################################

# source activate ncbi_datasets 
# 	cd /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref/Test
# 	datasets download genome accession GCF_000012205
# 	unzip *.zip 
# 	cp ncbi_dataset/data/GCF_000012205.*/*.fna ./
# 	rm -r *.zip README.md ncbi_dataset
# conda deactivate 