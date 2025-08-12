#!/usr/bin/env bash
#SBATCH -J CopyStrain
#SBATCH -p medium 
#SBATCH --mem=10G
#SBATCH -c 10 ###Number of cpus needed for each task

### Realpath of this file: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/copyStrains.sh ###

### Ensure the script stops on any error ###
set -e
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
###ZZ reminder: Need to sort out the issue - do not copy duplicate strains (same GCA code)
###ZZ reminder: check file type, .fasta or .fa?
###ZZ reminder: manually add a newline character at the end of the ${NAME_LIST} file using a text editor. Make sure that there is a newline character after the last strain name in the file.

# SOURCE_DIR="/mnt/shared/scratch/zzeng/genomes/assembly_AllSeq1797"
# DEST_DIR="/mnt/shared/scratch/zzeng/genomes/assembly_PG2d_OWsubclade17_31mNG"
# NAME_LIST="/mnt/shared/scratch/zzeng/NameList/PG2d_OWsubclade31"
# 
# mkdir -p "${DEST_DIR}"
# ###  Navigate to the source directory ###
# cd "${SOURCE_DIR}" || { echo "Source directory not found!"; exit 1; }

# # ##--- Copy READS ---###
### Read strain names from the list ###
# cat "${NAME_LIST}" | while IFS= read -r strain || [[ -n "$strain" ]]; do

# # ##--- Copy reads for GenBank ---###
#     ### Find and copy all .fastq.gz files related to the strain ###
# #     find "${SOURCE_DIR}" -type f \( -name "${strain}*_1.fastq.gz" -o -name "${strain}*_2.fastq.gz" \) -exec cp {} "${DEST_DIR}" \;
# 

# ##--- Copy trimmed reads for Snippy ---###
    # Source paths
#     fwd="/mnt/shared/scratch/zzeng/genomes/241185_248100/${strain}/trimmedReads/F/${strain}_*_1_trim.fq.gz"
#     rev="/mnt/shared/scratch/zzeng/genomes/241185_248100/${strain}/trimmedReads/R/${strain}_*_2_trim.fq.gz"
# 
#     # Copy to destination
#     cp $fwd $DEST_DIR    
#     cp $rev $DEST_DIR
#     
#     ### Check if the files were copied successfully ###
#     if [ $? -eq 0 ]; then
#         echo "Files for ${strain} copied successfully."
#     else
#         echo "Error: No matching files found for strain: ${strain}"
#     fi
# done < "${NAME_LIST}"
# 
# echo "Genome file copying completed!"

### --- Copy ASSEMBLIES --- ####
# while IFS= read -r strain; do
#     ### Expected directory where the .fa file should be ###
#     strain_dir="${SOURCE_DIR}"
# ### "${SOURCE_DIR}/${strain}/assembly/filtered_contigs" #JC original dir
# 
#     ### Find the matching .fa file ###
#     fa_file=$(find "${strain_dir}" -type f -name "${strain}*min_500bp.fa")
# 
#     if [[ -f "$fa_file" ]]; then
#         cp "$fa_file" "$DEST_DIR"
#         echo "File for ${strain} copied successfully."
#     else
#         echo " Warning: No matching .fa file found for strain ${strain}"
#     fi
# done < "$NAME_LIST"
# 
# echo "Genome file copying completed!"

################################################################################################################
###Change file name (barcode_1.fastq.gz) while copying genomes
# while IFS= read -r strain; do
#     # Find files that start with strain ID and end with _1.fastq.gz or _2.fastq.gz
#     for file in $(find "${SOURCE_DIR}" -type f \( -name "${strain}*_1.fastq.gz" -o -name "${strain}*_2.fastq.gz" \)); do
#         # Extract the suffix (_1.fastq.gz or _2.fastq.gz)
#         suffix=$(echo "$file" | grep -oE "_[12]\.fastq\.gz")

#         # Rename and copy the file to DEST_DIR as "strain_1.fastq.gz" or "strain_2.fastq.gz"
#         cp "$file" "${DEST_DIR}/${strain}${suffix}"
        
#         echo "Renamed and copied: ${strain}${suffix}"
#     done
# done < "${NAME_LIST}"

# echo "File renaming and copying completed!"
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
# cd /mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNG_Field_Ps243
# cp /mnt/shared/scratch/zzeng/pseudomonas_genomes/ANIref_uniq860/* /mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNG_Field_Ps243

################################################################################################################
###Move strains on the name list from a folder to another folder

# NAME_LIST="/home/zzeng/scratch/NameList_Sampling_202.txt"
# SOURCE_DIR="/home/zzeng/scratch/Genomes_Sampling494_d"
# TARGET_DIR="/mnt/shared/scratch/zzeng/Genomes_Sampling202"
# 
# # Ensure the target directory exists
# mkdir -p "$TARGET_DIR"
# 
# # Loop through each filename in the list
# while read -r filename; do
#   # Construct the full file path
#   FILE_PATH="$SOURCE_DIR/$filename"
# 
#   # Check if the file exists
#   if [[ -f "$FILE_PATH" ]]; then
#     mv "$FILE_PATH" "$TARGET_DIR/"
#     echo "Moved: $filename"
#   else
#     echo "File not found: $filename"
#   fi
# done < "$NAME_LIST"

######################################################################################################
### Move strains on the name list from a folder to another folder (IF only part of the file name is on the list) ###
# NAME_LIST="/mnt/shared/scratch/zzeng/NameList/PG2d_OWsubclade"
# SOURCE_DIR="/mnt/shared/scratch/zzeng/bakta/results_PG2d302"
# TARGET_DIR="/mnt/shared/scratch/zzeng/bakta/results_PG2d302_PG2dOWsubclade27"
# 
# ### Ensure the target directory exists ###
# mkdir -p "$TARGET_DIR"
# 
# ### Loop through each pattern in the list ###
# while read -r pattern; do
#   ### Use glob to match files containing the pattern f for file while d for folder. Need to change cp/cp -r as well! ###
# #   matches=$(find "$SOURCE_DIR" -maxdepth 1 -type f -name "*$pattern*")
#   matches=$(find "$SOURCE_DIR" -maxdepth 1 -type d -name "*$pattern*")
# ### Use [[ -n "$var" ]] to check if a variable is non-empty. Use [ "$(ls -A dir)" ] to check if a directory is non-empty. ###
#   if [[ -n "$matches" ]]; then
#     for file in $matches; do
#       cp -r "$file" "$TARGET_DIR/"
#       echo "Copied: $(basename "$file")"
#     done
#   else
#     echo "No match for: $pattern"
#   fi
# done < "$NAME_LIST"

######################################################################################################
### Copy gff3 files from subfolders directly ###
NAME_LIST="/mnt/shared/scratch/zzeng/NameList/SamplingPs540Ref39"
# "/mnt/shared/scratch/zzeng/NameList/PG2d_PT2021_149"
SOURCE_DIR="/mnt/shared/scratch/zzeng/bakta/results_All1797Ref39"
TARGET_DIR="/mnt/shared/scratch/zzeng/bakta/results_SamplingPs540Ref39"

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Loop through each pattern in the list
while read -r pattern; do
  # Find directories matching the pattern
  matches=$(find "$SOURCE_DIR" -maxdepth 1 -type d -name "*$pattern*")
  # If the variable $matches is non-empty (i.e., contains something), then do the next block.
  if [[ -n "$matches" ]]; then
    for dir in $matches; do
      # Copy .gff3 files inside the matching directory
      for file in "$dir"/*.fna; do
      # If the path stored in $file is a regular file (not a directory, device, etc.), then do the next block.
        if [[ -f "$file" ]]; then
          cp "$file" "$TARGET_DIR/"
          echo "Copied: $(basename "$file") from $(basename "$dir")"
        fi
      done
    done
  else
    echo "No directory match for pattern: $pattern"
  fi
done < "$NAME_LIST"

######################################################################################################
###Move subfolders (within a main folder) only if they contain exactly 15 files
###Set your source and target directory
# SOURCE_DIR="/mnt/shared/scratch/zzeng/bakta/LightDB_Failed_GCA"
# TARGET_DIR="/mnt/shared/scratch/zzeng/bakta/Complete_LightDB_PG2d_Sampling124Field75Ref100ReSeq1PG2b1"
# 
# # Create target dir if it doesn't exist
# # mkdir -p "$TARGET_DIR"
# 
# # Loop through each subfolder in the source
# for subdir in "$SOURCE_DIR"/*/; do
#   # Count number of regular files in the subfolder
#   file_count=$(find "$subdir" -type f | wc -l)
# 
#   if [ "$file_count" -eq 15 ]; then
#     echo "Moving $subdir with $file_count files"
#     mv "$subdir" "$TARGET_DIR"
#   else
#     echo "Skipping $subdir (contains $file_count files)"
#   fi
# done

######################################################################################################
###Copy files to another folder and split files into multiple subfolders
# SRC_DIR="/mnt/shared/scratch/zzeng/bakta/genomes_PG2d_Sampling124Field75Ref100ReSeq1PG2b1"
# DST_DIR="/mnt/shared/scratch/zzeng/bakta/genomes_PG2d_Sampling124Field75Ref100ReSeq1PG2b1_copy"
# NUM_SPLITS=3
# 
# # Step 1: Copy the directory
# cp -r "$SRC_DIR" "$DST_DIR"
# 
# # Step 2: Create split folders
# for i in $(seq 1 $NUM_SPLITS); do
#     mkdir -p "$DST_DIR/split_$i"
# done
# 
# # Step 3: Distribute files evenly
# count=0
# for file in "$DST_DIR"/*; do
#     # Skip subdirs (like the split folders we just made)
#     [[ -d "$file" ]] && continue
#     ((folder_idx=(count % NUM_SPLITS) + 1))
#     mv "$file" "$DST_DIR/split_$folder_idx/"
#     ((count++))
# done

######################################################################################################
### Copy large dir
# TARGET_DIR="/mnt/apps/users/zzeng/archive/pseudomonasSequencingData_zeng1_to_10_and_1234567p8p10_Wed_18_Oct_2023_14_16_09/241185_248100"
# DST_DIR="/mnt/shared/scratch/zzeng/genomes"
# 
# # Create target dir if it doesn't exist
# mkdir -p "$DST_DIR"
# 
# mv "$TARGET_DIR" "$DST_DIR"
# echo "Move completed!"

######################################################################################################
### Delete large dir
# TARGET_DIR="/mnt/apps/users/zzeng/archive"
# 
# # Create target dir if it doesn't exist
# rm -rf "$TARGET_DIR"
# 
# echo "Deletion completed!"
