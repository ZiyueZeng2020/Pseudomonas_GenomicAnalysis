#!/usr/bin/env bash 
#SBATCH -p himem
#SBATCH -J IQtree
#SBATCH --mem=180G
#SBATCH --cpus-per-task=20

### Real path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/IQtree2025.sh

### Ensure the script stops on any error ###
set -e

ALIGNMENT_DIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_SamplingPs540Ref39/Output98"  
IQTREE_DIR="${ALIGNMENT_DIR}/iqtree_MFP"
FILE_NAME="core_gene_alignment_filtered.aln"
PREFIX="SamplingPs540Ref39_Panaroo"
#"${FILE_NAME%%.*}"

echo "Alignment file: $FILE_NAME"
echo "Prefix for IQ-TREE: $PREFIX"

### Create output directory if it doesn't exist ###
mkdir -p $IQTREE_DIR

### Collect alignment file from Panaroo folders ###
echo "Collecting alignment file..."
### Collect alignment file from Panaroo folder, exclude output folder to avoid self-copy ###
find "$ALIGNMENT_DIR" -mindepth 1 -type f -name "${FILE_NAME}" \
  ! -path "$IQTREE_DIR/*" \
  -exec cp {} "$IQTREE_DIR/" \;
  
### Check if any files were collected. [ ... ]: Tests whether that output is non-empty. ls -a Lists all files, including . and .. ###
### Use [[ -n "$var" ]] to check if a variable is non-empty. Use [ "$(ls -A dir)" ] to check if a directory is non-empty. ###
if [ "$(ls -A $IQTREE_DIR)" ]; then
    echo "Found $(ls -1 $IQTREE_DIR | wc -l) alignment files. Proceeding with iqtree..."
else
    echo "No alignment file found!"
    exit 1
fi

# Run iqtree
echo "Running iqtree..."

cd "$IQTREE_DIR"
## Activate iqtree environment (iqtree version 2.4.0) ###
## Standard model selection (-m TEST option) or the new ModelFinder (-m MFP) ###
## Add the -safe flag to use log-likelihood computations to avoid these underflows — it's slightly slower, but more stable numerically ###
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/iqtree
iqtree2 -s "$IQTREE_DIR"/"${FILE_NAME}" \
--prefix "${PREFIX}" \
-B 1000 \
-T AUTO \
-m MFP \
-safe

conda deactivate

echo "Tree construction complete! Output files in $IQTREE_DIR"

# Re-name tree labeling
# cp /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/SUPERMATRIX.phylip.treefile  Rename_SUPERMATRIX.phylip.treefile
# for x in $(cat /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/Rename_SUPERMATRIX.phylip.treefile | sed -e 's/:/\n/g' -e 's/,/\n/'g| sed 's/(//g'| grep "GCA"); do 
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	#echo ${x} ${gca}
# 	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1| grep ${gca})
# 	echo ${x} ${gca} ${PGname}
# 	sed -i "s/${x}/${PGname}/g" /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/Rename_SUPERMATRIX.phylip.treefile
# done 
