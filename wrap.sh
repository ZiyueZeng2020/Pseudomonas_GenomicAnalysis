#!/bin/bash
#SBATCH -J wrap
#SBATCH -p long
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1


###Real path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/wrap.sh

# Specify the input folder containing the original files
input_folder="/mnt/shared/home/zzeng/scratch/pseudomonas_genomes/mNG/mNGField_Ps267_ANI860"

# Specify the output folder for the new files
output_folder="/mnt/shared/home/zzeng/scratch/pseudomonas_genomes/mNG/mNGField_Ps267_ANI860_fna_wrap"

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Define the desired line length (e.g., 80 characters)
desired_line_length=80

for input_file in "$input_folder"/*; do
  if [ -f "$input_file" ]; then
    # Process each file
    # echo "Processing: $input_file"
    
    # Define the output file name with "wrap_" prefix
    output_file="$output_folder/wrap_$(basename "$input_file")"
    
    # Use awk to wrap sequence lines and preserve header lines
    awk '/^>/ {if (NR>1) print ""; printf("%s\n",$0); next;} {printf("%s",$0);} END {print "";}' "$input_file" | \
    fold -w "$desired_line_length" > "$output_file"
    
    # echo "New file created: $output_file"
  fi
done

echo "Processing complete."