#!/usr/bin/env bash 
#SBATCH -p long
#SBATCH -J buscoPhylogeny 
#SBATCH --mem=8G
#SBATCH --cpus-per-task=64

source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/iqtree
cd /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZmtree_Bdb/supermatrix

iqtree -s SUPERMATRIX.phylip \
-bb 1000 \
-nt 8 \
-m MF \
-mtree \
-wbtl \
-safe
conda deactivate

cp /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZmtree_Bdb/supermatrix/SUPERMATRIX.phylip.treefile Z1_SUPERMATRIX.phylip.treefile
for x in $(cat /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZmtree_Bdb/supermatrix/Z1_SUPERMATRIX.phylip.treefile| sed -e 's/:/\n/g' -e 's/,/\n/'g| sed 's/(//g'| grep "GCA"); do 
	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
	#echo ${x} ${gca}
	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonasProject/strainName/ref25PGf1| grep ${gca})
	echo ${x} ${gca} ${PGname}
	sed -i "s/${x}/${PGname}/g" /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZmtree_Bdb/supermatrix/Z1_SUPERMATRIX.phylip.treefile
done 
