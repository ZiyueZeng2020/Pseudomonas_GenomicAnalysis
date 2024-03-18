#!/usr/bin/env bash 
#SBATCH -p long
#SBATCH -J IQtree
#SBATCH --mem=150G
#SBATCH --cpus-per-task=64


#ZZ reminder:
#Check memory
#Check CPU
#If change the -m setting to be "-m MF \ -mtree \", it wont be compatibele with other settings (ModelFinder only cannot be combined with bootstrap analysis.), and the script wont work. 
#-bb 10000 did not improve the performce of topology. So the settign should be kept the same as original.

#Realpath of this sciprt: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/IQtree.sh

source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/iqtree
cd /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/tree1204/supermatrix

iqtree -s SUPERMATRIX.phylip \
-bb 1000 \
-nt AUTO \
-m JTT+I+G \
-wbtl \
-safe
conda deactivate

# cp mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZ10000_Bdb/supermatrix/SUPERMATRIX.phylip.treefile Z1_SUPERMATRIX.phylip.treefile
# for x in $(cat /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZ10000_Bdb/supermatrix/Z1_SUPERMATRIX.phylip.treefile| sed -e 's/:/\n/g' -e 's/,/\n/'g| sed 's/(//g'| grep "GCA"); do 
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	#echo ${x} ${gca}
# 	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonasProject/strainName/ref25PGf1| grep ${gca})
# 	echo ${x} ${gca} ${PGname}
# 	sed -i "s/${x}/${PGname}/g" /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZ10000_Bdb/supermatrix/Z1_SUPERMATRIX.phylip.treefile
# done 
