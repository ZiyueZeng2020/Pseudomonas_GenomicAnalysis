#!/usr/bin/env bash
#SBATCH -p short 
#SBATCH -J reName
#SBATCH --mem=4G
#SBATCH --cpus-per-task=2

#Realpath of this file: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/renameStrain.sh

### Check whehter GCA in column 1 contains duplicates: awk '{print $1}' NameCheck_Ref.txt | sort | uniq -d
### Check the number of unique GCA in column 1: cut -d' ' -f1 NameCheck_Ref.txt|sort|uniq|wc -l

###############################################################################################################
# #Make new name list
# for x in $(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1); do
# gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# echo ${gca} ${x}
# done > ref25PGf2
# #Delete the second occurrance
# awk '!seen[$1]++' GenBankPs_cerasi_PG22 > GenBankPs_cerasi_PG22

###############################################################################################################
#Change GCA strain name in Tree file. TestedFunctional:)
# ZZ Reminder:

# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/corePhyloTree/mNGSampPG2bd311PG2ref324PG3ref1/IQtree
# OriginalFile=${FileFolder}/combined.nex.treefile

# cd ${FileFolder}
# cp ${OriginalFile} mNGSampPG2bd311PG2ref324PG3ref1_RNref.treefile

# FileToRename=${FileFolder}/mNGSampPG2bd311PG2ref324PG3ref1_RNref.treefile

# newNameFile=/mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/GenbankPs/AV_323PG2_incl1PG3.txt
#/mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/GenbankPs/GenBankPs_cerasi_PG25_AdditionalPsRef

# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/g' -e 's/(/\n/g'| grep "GCA"); do 
# gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")

# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/g' -e 's/(/\n/g'| grep "GCF"); do 
# 	gca=$(echo ${x} | grep -oE "G[CA]F_[0-9]+")
# 	# echo ${gca} ${x}
# 	newName=$(cat ${newNameFile}|cut -f 2|grep ${gca}|sort|uniq)
# 	# echo ${gca} ${x} ${newName} >> NameCheck_Ref.txt
# 	sed -i "s/${x}/${newName}/g" ${FileToRename}
# done 

#Filter and extract lines where the 3rd column is empty
# awk '$3 == ""' NameCheck_Ref.txt> EmptyNewName_ref.txt
# wc -l NameCheck_Ref.txt

###############################################################################################################
#Change mNG strain name in a Tree file from Barcode_min_500bp to Barcode_IsolateName_ANIhit
#ZZ Reminder:
# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/tMRCA/SNPtree1
# OriginalFile=${FileFolder}/filtered_snps.treefile

# cd ${FileFolder}
# # cp ${OriginalFile} PG2dPT_SNPtree_rn.treefile

# FileToRename=${FileFolder}/PG2dPT_SNPtree_rn.treefile
# newNameFile=/mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/mNG/List_mNG_Sampling_PG2bd311_PG2dSubcladeNumber
#/mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/mNG/List_mNG_Sampling_PG2d_PT69_SubcladeNumber
#/mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/mNG/List_mNG_PG2bd311_clade
#/mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/mNG/List_mNG_All1797_IsolateName_ANIhit

###Filter for mNGbarcodes_min_500bp
# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/g' -e 's/(/\n/g'|grep '_min_500bp$'); do
        # mNGBarcode=$(echo ${x} | cut -d "_" -f1)

###Filter for mNGbarcodes 6 digits starting with 24
# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/g' -e 's/(/\n/g'| grep -E '\b24[0-9]{4}\b'); do
#         mNGBarcode=$(echo ${x})
#         newName=$(grep -o ".*${mNGBarcode}.*" "${newNameFile}")
#         # echo ${mNGBarcode} ${x} ${newName} >> NameCheck_mNG.txt
#         sed -i "s/${x}/${newName}/g" ${FileToRename}   
# done 

# awk '$3 == ""' NameCheck_mNG.txt> EmptyNewName_mNG.txt
# wc -l NameCheck_mNG.txt
### cat PG2dPT_PanarooTree_rn.treefile | sed -e 's/:/\n/g' -e 's/,/\n/g' -e 's/(/\n/g' | grep 'PG2d-'|wc -l

###Alternative grep: grep -Eo "[0-9]+_min_500bp|[0-9]+_[0-9]+x_min_500bp"
###############################################################################################################
# #Change mNG strain name in a Tree file from Barcode_IsolateName to Barcode_IsolateName_ANIhit
# #ZZ Reminder:
# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/mlstPhyloTree
# OriginalFile=${FileFolder}/CoreGenomePhyloTree_mNG_Sampling1101_ReNamed_ReNamedRef.treefile

# cd ${FileFolder}
# cp ${OriginalFile} CoreGenomePhyloTree_mNG_Sampling1101_ReNamedRef_ReNamedmNGANIhit.treefile

# FileToRename=${FileFolder}/CoreGenomePhyloTree_mNG_Sampling1101_ReNamedRef_ReNamedmNGANIhit.treefile
# newNameFile=/mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/mNG/List_mNG_All1797_IsolateName_ANIhit

# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/g' -e 's/(/\n/g'|grep -E '^[0-9]{6}_.*_.*$'); do
#         mNGBarcode=$(echo ${x} | cut -d "_" -f1)
#         newName=$(cat ${newNameFile} | grep -o "^${mNGBarcode}.*")
#         # echo ${mNGBarcode} ${x}  ${newName} >> NameCheck_mNG_ANIhit.txt
#         sed -i "s/${x}/${newName}/g" ${FileToRename}
# done 
###############################################################################################################
#Change GCA strain name in a ANI.tab file 
#ZZ Reminder:

# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/ANI/fANI/Field267ANI860
# OriginalFile=${FileFolder}/mNGField_Ps267_ANI860_fna_wrap_combined_matrix.txt
# cd ${FileFolder}
# cp ${OriginalFile} fANI_mNG_Ps267_ANI860_RNref.tab

# FileToRename=${FileFolder}/fANI_mNG_Ps267_ANI860_RNref.tab

# for x in $(cat ${FileToRename}| sed -e 's/\t/\n/g'| grep "GCA"); do 
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	NewName=$(cat /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/GenbankPs/GenBankPs_cerasi_PG25_AdditionalPsRef| cut -f2| grep ${gca}|sort|uniq)
# 	echo ${gca} ${x} ${NewName} >>NameCheck_Ref.txt
# 	sed -i "s/${x}/${NewName}/g" ${FileToRename}
# done

# awk '$3 == ""' NameCheck_Ref.txt> EmptyNewName_ref.txt
# wc -l NameCheck_Ref.txt

###############################################################################################################
#Change mNG strain name in a ANI.tab file from Barcode_min_500bp to Barcode_IsolateName_ANIhit
#ZZ Reminder:

# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/ANI/fANI/Field267ANI860
# OriginalFile=${FileFolder}/fANI_mNG_Ps267_ANI860_RNref.tab
# cd ${FileFolder}
# cp ${OriginalFile} fANI_mNG_Ps267_ANI860_RNrefRNmNG.tab

# FileToRename=${FileFolder}/fANI_mNG_Ps267_ANI860_RNrefRNmNG.tab

# for x in $(cat ${FileToRename} | sed -e 's/\t/\n/g' | grep '_min_500bp$'); do 
#     mNGBarcode=$(echo ${x} | grep -oE "[0-9]{6}")
#     NewName=$(cat /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/mNG/List_mNG_All1797_IsolateName_ANIhit | grep -o "^${mNGBarcode}.*" | uniq)
#     echo ${mNGBarcode} ${x} ${NewName} >>NameCheck_mNG.txt
#     sed -i "s/${x}/${NewName}/g" ${FileToRename}
# done

# awk '$3 == ""' NameCheck_mNG.txt> EmptyNewName_mNG.txt
# wc -l NameCheck_mNG.txt
###############################################################################################################
###Change mNG strain name in a ANI.tab file from Barcode_IsolateName to Barcode_IsolateNameANIhit
###ZZ Reminder:
# FileFolder=/mnt/shared/projects/niab/ZZeng/ANI/mNG/mNGSampling4PG22_fasta_wrap_New
# OriginalFile=${FileFolder}/ANI_mNG_Sampling1123_Rename.tab
# cd ${FileFolder}
# # cp ${OriginalFile} ANI_mNG_Sampling1123_RenameMNGANIhit.tab

# FileToRename=${FileFolder}/ANI_mNG_Sampling1123_RenameMNGANIhit.tab

# for x in $(cat ${FileToRename} | sed -e 's/\t/\n/g' | grep -E '^[0-9]{6}_.*_.*$'); do 
#     mNGBarcode=$(echo ${x} | grep -oE "[0-9]{6}")
#     # echo ${mNGBarcode} ${x}
#     NewName=$(cat /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/mNG/List_mNG_All1797_IsolateName_ANIhit | grep -o "^${mNGBarcode}.*" | uniq)
#     echo ${mNGBarcode} ${x} ${NewName} >> NameCheck_mNG_ANIhit2.txt
#     sed -i "s/${x}/${NewName}/g" ${FileToRename}
# done
###############################################################################################################
#Change mNG strain name in a Fast ANI matix file from Barcode_min_500bp to Barcode_IsolateName_ANIhit
#ZZ Reminder:

# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/ANI/fANI/Field267ANI860
# OriginalFile=${FileFolder}/fANI_mNG_Ps267_ANI860_RNref.tab
# cd ${FileFolder}
# cp ${OriginalFile} fANI_mNG_Ps267_ANI860_RNrefRNmNG.tab

# FileToRename=${FileFolder}/fANI_mNG_Ps267_ANI860_RNrefRNmNG.tab

# for x in $(cat ${FileToRename} | sed -e 's/\t/\n/g' | grep '_min_500bp*'); do 
#     mNGBarcode=$(echo ${x} | grep -oE "[0-9]{6}")
#     NewName=$(cat /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/mNG/List_mNG_All1797_IsolateName_ANIhit | grep -o "^${mNGBarcode}.*" | uniq)
#     echo ${mNGBarcode} ${x} ${NewName} >>NameCheck_mNG.txt
#     sed -i "s/${x}/${NewName}/g" ${FileToRename}
# done

# awk '$3 == ""' NameCheck_mNG.txt> EmptyNewName_mNG.txt
# wc -l NameCheck_mNG.txt


####grep '_min_500bp*' matches strings containing "_min_500bp" followed by zero or more characters.
####grep '_min_500bp$' matches strings that end exactly with "_min_500bp".
###############################################################################################################
#To check number of genomes in the combined nuxes file. TestedFunctional:)
# FileToRename=/mnt/shared/scratch/zzeng/pseudomonasProject/ANIref/nexus/combined_copy.nex

# for x in $(cat ${FileToRename}| sed -e 's/-/\n/g' -e 's/,/\n/'g| sed 's/?//g'| grep "GCA_"); do 
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	echo ${gca}
# done > /mnt/shared/scratch/zzeng/pseudomonasProject/BlastGCAlist.txt

# sort BlastGCAlist.txt|uniq -c|wc -l

# ################################################################################################################
###rename genome file###
#Rename file name using NameListFile file based on SHARED GCA - ONLY ONE COLUMN in NameListFile. TestedFunctional:)
# for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9); do
# 	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${x}
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1 | grep ${gca})
# 	#echo ${x} ${genome} ${gca} ${PGname}
# 	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${PGname}
# done
################################################################################################################
###rename genome file###
#Rename file name using NameListFile file based on SHARED GCA - MULTIPLE COLUMNS in NameListFile. TestedFunctional:)
for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9); do
	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${x} 
	ShortName=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1 |grep ${x}|cut -f2)
	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${ShortName} 
done
# # ################################################################################################################
# # Add .fna to files. TestedFunctional:)
# for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG); do
# 	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG/${x} 
# 	fnaName=${x}.fna 
# 	#echo ${genome} ${fnaName}
# 	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG/${fnaName} 
# done

# # ################################################################################################################
#Rename treefile from ANI_Blasthit to mNG barcode

# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/corePhyloTree/SubTreePG2dPT67
# OriginalFile=${FileFolder}/SubTreePG2dPT67.nwk

# cd ${FileFolder}
# cp ${OriginalFile} SubTreePG2dPT6_rRNmNG.nwk

# FileToRename=${FileFolder}/SubTreePG2dPT6_rRNmNG.nwk
# ###Check original treefile. Defult: |grep '_min_500bp$'); do
# ###| cut -d "_" -f1)

# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/g' -e 's/(/\n/g'|grep '_'); do
#         mNGBarcode=$(echo ${x} | cut -d "_" -f1)
#         # echo ${mNGBarcode} ${x}  >> NameCheck_mNG.txt
#         sed -i "s/${x}/${mNGBarcode}/g" ${FileToRename}   
# done 

# # ################################################################################################################

###rename all the .fa files to be .fna or fasta
faToFsata(){
for file in *.fa; do
    mv "$file" "${file%.fna}.fna"
done
}
#🌷🌷🌷
#faToFsata

###Another example (change .fna.fasta to .fasta): 
# for file in *.fa; do
#    mv "$file" "${file%.fa}.fna"
# done