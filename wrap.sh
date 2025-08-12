#!/bin/bash
#SBATCH -J wrap
#SBATCH -p short
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1

# Real path of this script:
# sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/wrap.sh

# Input folder with original FASTA files
input_folder="/mnt/shared/scratch/zzeng/fANI/g1"

# Output folder for wrapped FASTA files
output_folder="/mnt/shared/scratch/zzeng/fANI/g1_wrap"

# Create the output folder if it doesn't exist
mkdir -p "$output_folder"

# Loop through each file in the input folder
for input_file in "$input_folder"/*; do
  if [ -f "$input_file" ]; then
    output_file="$output_folder/wrap_$(basename "$input_file")"
    
    # Wrap sequence lines (80 bp width) and ensure proper FASTA format
    awk '
      BEGIN {seq = ""}
      /^>/ {
        if (seq != "") {
          while (length(seq) > 0) {
            print substr(seq, 1, 80)
            seq = substr(seq, 81)
          }
          seq = ""
        }
        print $0
        next
      }
      {
        gsub(/\s+/, "", $0)
        seq = seq $0
      }
      END {
        if (seq != "") {
          while (length(seq) > 0) {
            print substr(seq, 1, 80)
            seq = substr(seq, 81)
          }
        }
      }
    ' "$input_file" > "$output_file"

    echo "Wrapped: $(basename "$input_file") → $(basename "$output_file")"
  fi
done

echo "Wrapping complete."
