#!/usr/bin/env bash
#SBATCH -J CopyStrain
#SBATCH -p short 
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4

#Realpath of this file: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/copyStrains.sh

################################################################################################################
#Copy strains while strain names are the SAME as the names in the list
# for x in $(cat /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/ANIref844_AddPathogen16_uniq860.txt); do 
# 	#Print the path of the files to check Functional:)
# 	genome=/mnt/shared/scratch/jconnell/pseudomonasProject/Ps_genomes_2795/ncbi_dataset/data/${x}/*
# 	echo ${x}
# 	#The other way to print the path, no need to define:
# 	#ls genome=/mnt/shared/scratch/jconnell/pseudomonasProject/Ps_genomes_2795/ncbi_dataset/data/${x}/*
# 	cp /mnt/shared/scratch/jconnell/pseudomonasProject/Ps_genomes_2795/ncbi_dataset/data/${x}/* /mnt/shared/home/zzeng/scratch/pseudomonas_genomes/ANIref860; 
# done
# ################################################################################################################
###Copy strains while strain names are NOT the same as the names in the list
###ZZ reminder: Need to sort out the issue - do not copy duplicate strains (same GCA code)
###ZZ reminder: check file type, .fasta or .fa?
###ZZ reminder: manually add a newline character at the end of the ${NAME_LIST} file using a text editor. Make sure that there is a newline character after the last strain name in the file.
# SOURCE_DIR="/mnt/shared/projects/niab/pseudomonas/pseudomonasSequencingData_zeng1_to_10_and_1234567p8p10_Wed_18_Oct_2023_14_16_09/241185_248100"
# DEST_DIR="/mnt/shared/home/zzeng/scratch/pseudomonas_genomes/mNG/List_mNG_Field_Ps243_ANI860"
# NAME_LIST="/mnt/shared/home/zzeng/scratch/pseudomonas_genomes/strainName/mNG/List_mNG_WP13_Ps"

# mkdir -p ${DEST_DIR}
# cd "${SOURCE_DIR}"

# while IFS= read -r x; do
#     assembly=$(find "${SOURCE_DIR}/${x}/assembly/filtered_contigs" -name "*.fa" -type f)
#     if [ -n "$assembly" ]; then
#         cp "$assembly" "${DEST_DIR}"
#     else
#         echo "Assembly file not found for strain: $x"
#     fi
# done < "${NAME_LIST}"
################################################################################################################
###Find the missing file
# Loop through each name in the list
# while IFS= read -r name_part; do
#     # Check if any file in the folder matches the name part from the list
#     if ! ls "$DEST_DIR"/*"${name_part}"* >/dev/null 2>&1; then
#         echo "File with prefix '$name_part' is missing in the folder."
#     fi
# done < "$NAME_LIST"

################################################################################################################
# for name in $(cat "$NAME_LIST")
# do
#     # Find files in source directory containing the name and copy them to the destination directory
#     find "$SOURCE_DIR" -type f -name "*$name*" -exec cp {} "$DEST_DIR" \;
# done

################################################################################################################
cd /mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNG_Field_Ps243
cp /mnt/shared/scratch/zzeng/pseudomonas_genomes/ANIref_uniq860/* /mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNG_Field_Ps243