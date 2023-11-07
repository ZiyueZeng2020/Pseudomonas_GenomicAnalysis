#!/usr/bin/env bash


#Realpath of this file: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/renameStrain.sh

###############################################################################################################
#Change strain name in a phylo tree file TestedFunctional:)
cp /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZ10000_Bdb/supermatrix/SUPERMATRIX.phylip.treefile Z1_SUPERMATRIX.phylip.treefile
for x in $(cat /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZ10000_Bdb/supermatrix/Z1_SUPERMATRIX.phylip.treefile| sed -e 's/:/\n/g' -e 's/,/\n/'g| sed 's/(//g'| grep "GCA"); do 
	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
	#echo ${x} ${gca}
	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1| grep ${gca})
	echo ${x} ${gca} ${PGname}
	sed -i "s/${x}/${PGname}/g" /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/ZZ10000_Bdb/supermatrix/Z1_SUPERMATRIX.phylip.treefile
done
###############################################################################################################
#To changing names in a ANI file
# for x in $(cat /mnt/shared/scratch/zzeng/alignmentResults3| sed -e 's/\//\n/g'|grep "GCA" | cut -f1 -d$'\t'); do
# 	gca=$(echo ${x}| grep -oE "GCA_[0-9]+\.[0-9]")
# 	PGname=$(cat /mnt/shared/scratch/zzeng/newName | grep ${gca})
# 	#echo ${x} ${fna} ${gca} ${PGname}
# 	sed -i "s/${x}/${PGname}/g" /mnt/shared/scratch/zzeng/alignmentResults3
# 	sed -i 's|/home/jconnell/jconnell/pseudomonasProject/MNGTree/assemblys/||g' /mnt/shared/scratch/zzeng/alignmentResults3
# done

#sed -e 's/\s\+/\n/g'

# ################################################################################################################
# ###rename genome file###
# #Rename file name using NameListFile file based on SHARED GCA - only one column in NameListFile. TestedFunctional:)
for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9); do
	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${x}
	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1 | grep ${gca})
	#echo ${x} ${genome} ${gca} ${PGname}
	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${PGname}
done
################################################################################################################
###rename genome file###
#Rename file name using NameListFile file based on SHARED GCA - multiple columns in NameListFile. TestedFunctional:)
for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9); do
	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${x} 
	ShortName=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1 |grep ${x}|cut -f2)
	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${ShortName} 
done
# ################################################################################################################
# Add .fna to files. TestedFunctional:)
for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG); do
	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG/${x} 
	fnaName=${x}.fna 
	#echo ${genome} ${fnaName}
	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG/${fnaName} 
done




