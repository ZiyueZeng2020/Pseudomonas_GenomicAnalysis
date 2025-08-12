#!/usr/bin/env bash 
#SBATCH -p long
#SBATCH -J IQtree
#SBATCH --mem=20G
#SBATCH --cpus-per-task=10

# Real path of this script: /home/zzeng/git_hub/scripts/pseudomonasAnalysis/IQtree2025.sh

ALIGNMENT_DIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_Pss9644Variants43ReSeq1/Output98"  
IQTREE_DIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_Pss9644Variants43ReSeq1/Output98/iqtree"

# Create output directory if it doesn't exist
mkdir -p $IQTREE_DIR

# Collect alignment file from Panaroo folders
echo "Collecting alignment file..."
find "$ALIGNMENT_DIR" -mindepth 1 -type f -name "core_gene_alignment_filtered.aln" -exec cp {} "$IQTREE_DIR" \;

cd "$IQTREE_DIR"

# activate iqtree environment (iqtree version 2.4.0)
# standard model selection (-m TEST option) or the new ModelFinder (-m MFP)
# source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/iqtree
# iqtree -s "$IQTREE_DIR"/core_gene_alignment_filtered.aln \
# --prefix Pss9644Variants44_98MTP
# -B 1000 \
# -T AUTO \
# -m MFP
# 
# conda deactivate

# Re-name tree labeling
# cp /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/SUPERMATRIX.phylip.treefile  Rename_SUPERMATRIX.phylip.treefile
# for x in $(cat /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/Rename_SUPERMATRIX.phylip.treefile | sed -e 's/:/\n/g' -e 's/,/\n/'g| sed 's/(//g'| grep "GCA"); do 
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	#echo ${x} ${gca}
# 	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1| grep ${gca})
# 	echo ${x} ${gca} ${PGname}
# 	sed -i "s/${x}/${PGname}/g" /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/Rename_SUPERMATRIX.phylip.treefile
# done 
