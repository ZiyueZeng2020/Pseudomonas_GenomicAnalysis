#!/usr/bin/env bash 
#SBATCH -p long
#SBATCH -J IQtree
#SBATCH --mem=8G
#SBATCH --cpus-per-task=64


# Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/IQtreeMtree.sh

# cd /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix

# source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/iqtree
# iqtree -s SUPERMATRIX.phylip \
# -bb 1000 \
# -nt 8 \
# -m JTT+I+G \
# -wbtl \
# -safe
# conda deactivate

#cp /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/SUPERMATRIX.phylip.treefile  Rename_SUPERMATRIX.phylip.treefile
for x in $(cat /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/Rename_SUPERMATRIX.phylip.treefile | sed -e 's/:/\n/g' -e 's/,/\n/'g| sed 's/(//g'| grep "GCA"); do 
	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
	#echo ${x} ${gca}
	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1| grep ${gca})
	echo ${x} ${gca} ${PGname}
	sed -i "s/${x}/${PGname}/g" /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/bacteria_db_tree/phylogenyResults/supermatrix/Rename_SUPERMATRIX.phylip.treefile
done 
