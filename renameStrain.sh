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
##Change GCA strain name in Tree file. TestedFunctional:)
##ZZ Reminder:
FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/corePhyloTree/mNGSamplingPs548PG39
OriginalFile=${FileFolder}/SamplingPs548PG39_RNref.treefile

cd ${FileFolder}
# cp ${OriginalFile} SamplingPs548PG39_RNref_RNmNG.treefile

FileToRename=${FileFolder}/SamplingPs548PG39_RNref_RNmNG.treefile

newNameFile=/mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/GenbankPs/GenBankPs_cerasi_PG25_AdditionalPsRef

for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/'g -e 's/(/\n/g'| grep "GCA"); do 
	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
	# echo ${gca} ${x}
	newName=$(cat ${newNameFile}|cut -f 2|grep ${gca}|sort|uniq)
	# echo ${gca} ${x} ${newName} >> NameCheck_Ref.txt
	sed -i "s/${x}/${newName}/g" ${FileToRename}
done 

###Filter and extract lines where the 3rd column is empty
# awk '$3 == ""' ANI892PG22ToBeFiltered >ANI892PG22ToBeFiltered_rows

###############################################################################################################
#Change mNG strain name in a Tree file from Barcode_min_500bp to Barcode_IsolateName_ANIhit
#ZZ Reminder:
# FileFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/corePhyloTree/mNGFieldPs243PG39
# OriginalFile=${FileFolder}/FieldPs243PG39

# cd ${FileFolder}
# # cp ${OriginalFile} FieldPs243PG39_RNref.treefile

# FileToRename=${FileFolder}/FieldPs243PG39_RNref.treefile
# newNameFile=/mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/mNG/List_mNG_All1797_IsolateName_ANIhit

# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/'g -e 's/(/\n/g'|grep '_min_500bp$'); do
#         mNGBarcode=$(echo ${x} | cut -d "_" -f1)
#         newName=$(cat ${newNameFile} | grep -o "^${mNGBarcode}.*")
#         # echo ${mNGBarcode} ${x}  ${newName} >> NameCheck_mNG.txt
#         sed -i "s/${x}/${newName}/g" ${FileToRename}
# done 

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

# for x in $(cat ${FileToRename}| sed -e 's/:/\n/g' -e 's/,/\n/'g -e 's/(/\n/g'|grep -E '^[0-9]{6}_.*_.*$'); do
#         mNGBarcode=$(echo ${x} | cut -d "_" -f1)
#         newName=$(cat ${newNameFile} | grep -o "^${mNGBarcode}.*")
#         # echo ${mNGBarcode} ${x}  ${newName} >> NameCheck_mNG_ANIhit.txt
#         sed -i "s/${x}/${newName}/g" ${FileToRename}
# done 
###############################################################################################################
#Change GCA strain name in a ANI.tab file 
#ZZ Reminder:

# FileFolder=/mnt/shared/projects/niab/ZZeng/ANI/mNG/mNGField369PG22_fasta_wrap
# OriginalFile=${FileFolder}/ANI_mNG_Field369PG22_ReNamedANIhit.tab
# cd ${FileFolder}
# # cp ${OriginalFile} ANI_mNG_Field369PG22_ReNamedANIhitRNref.tab

# FileToRename=${FileFolder}/ANI_mNG_Field369PG22_ReNamedANIhitRNref.tab

# for x in $(cat ${FileToRename}| sed -e 's/\t/\n/g'| grep "GCA"); do 
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	#echo ${gca} ${x}
# 	NewName=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/GenbankPs/GenBankPs_cerasi_PG25| cut -f2| grep ${gca}|sort|uniq)
# 	# echo ${gca} ${x} ${NewName} >>NameCheck_Ref.txt
# 	sed -i "s/${x}/${NewName}/g" ${FileToRename}
# done

# awk '$3 == ""' NewNameFile > NewNameFile_rows
###############################################################################################################
#Change mNG strain name in a ANI.tab file from Barcode_min_500bp to Barcode_IsolateName_ANIhit
#ZZ Reminder:
# FileFolder=/mnt/shared/projects/niab/ZZeng/ANI/mNG/mNGField369PG22_fasta_wrap
# OriginalFile=${FileFolder}/ANIm_percentage_identity.tab
# cd ${FileFolder}
# # mv ${OriginalFile} ANI_mNG_Field369PG22_ReNamedANIhit.tab

# FileToRename=${FileFolder}/ANI_mNG_Field369PG22_ReNamedANIhit.tab

# for x in $(cat ${FileToRename} | sed -e 's/\t/\n/g' | grep '_min_500bp$'); do 
#     mNGBarcode=$(echo ${x} | grep -oE "[0-9]{6}")
#     # echo ${mNGBarcode} ${x}
#     NewName=$(cat /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/mNG/List_mNG_All1797_IsolateName_ANIhit | grep -o "^${mNGBarcode}.*" | uniq)
#     # echo ${mNGBarcode} ${x} ${NewName} >> NameCheck_mNG.txt
#     sed -i "s/${x}/${NewName}/g" ${FileToRename}
# done

# awk '$3 == ""' NewNameFile > NewNameFile_rows
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
#To check number of genomes in the combined nuxes file. TestedFunctional:)
# FileToRename=/mnt/shared/scratch/zzeng/pseudomonasProject/ANIref/nexus/combined_copy.nex

# for x in $(cat ${FileToRename}| sed -e 's/-/\n/g' -e 's/,/\n/'g| sed 's/?//g'| grep "GCA_"); do 
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	echo ${gca}
# done > /mnt/shared/scratch/zzeng/pseudomonasProject/BlastGCAlist.txt

# sort BlastGCAlist.txt|uniq -c|wc -l

# ################################################################################################################
# ###rename genome file###
# #Rename file name using NameListFile file based on SHARED GCA - ONLY ONE COLUMN in NameListFile. TestedFunctional:)
# for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9); do
# 	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${x}
# 	gca=$(echo ${x} | grep -oE "GCA_[0-9]+\.[0-9]")
# 	PGname=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1 | grep ${gca})
# 	#echo ${x} ${genome} ${gca} ${PGname}
# 	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${PGname}
# done
# ################################################################################################################
# ###rename genome file###
# #Rename file name using NameListFile file based on SHARED GCA - MULTIPLE COLUMNS in NameListFile. TestedFunctional:)
# for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9); do
# 	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${x} 
# 	ShortName=$(cat /mnt/shared/scratch/zzeng/pseudomonas_genomes/strainName/ref25PGf1 |grep ${x}|cut -f2)
# 	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9/${ShortName} 
# done
# # ################################################################################################################
# # Add .fna to files. TestedFunctional:)
# for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG); do
# 	genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG/${x} 
# 	fnaName=${x}.fna 
# 	#echo ${genome} ${fnaName}
# 	mv ${genome} /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG/${fnaName} 
# done

# # ################################################################################################################
###rename all the .fa files to be .fna or fasta
faToFsata(){
for file in *.fa; do
    mv "$file" "${file%.fa}.fna"
done
}
#🌷🌷🌷
#faToFsata

###Another example (change .fna.fasta to .fasta): 
# for file in *.fa; do
#    mv "$file" "${file%.fa}.fna"
# done