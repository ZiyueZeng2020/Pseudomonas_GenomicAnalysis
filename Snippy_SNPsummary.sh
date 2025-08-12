#!/usr/bin/env bash
#SBATCH -J Snippy
#SBATCH -p short
#SBATCH --mem=1G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously
#SBATCH -c 1 ###Number of cpus needed for each task

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Snippy_SNPsummary.sh
# Set paths
BASE_DIR="/mnt/shared/scratch/zzeng/Snippy/Pss9644Variants43ReSeq1Trim_refLongGB"
RESULTS_DIR="$BASE_DIR/OUT_DIR"
OUTPUT_FILE="$BASE_DIR/SNP_tab_summary_Pss9644Variants43ReSeq1Trim_reSeqGB.csv"

# Write header (add Folder column before original snps.tab columns)
### Uses find to locate the first snps.tab file. head -n 1: Extracts the first line (header) from that file.
echo -e "Strain\t$(head -n 1 $(find "$RESULTS_DIR" -type f -name snps.tab | head -n 1))" > "$OUTPUT_FILE"

# Loop through each subfolder
for folder in "$RESULTS_DIR"/*/; do
    folder_name=$(basename "$folder")
    tab_file="${folder}/snps.tab"

    if [[ -f "$tab_file" ]]; then
        # Skip header and check if there's SNP data
        data_lines=$(tail -n +2 "$tab_file")

        if [[ -n "$data_lines" ]]; then
            # Prepend folder name to each line and append to output
            echo "$data_lines" | awk -v f="$folder_name" 'BEGIN{OFS="\t"} {print f, $0}' >> "$OUTPUT_FILE"
        else
            echo -e "${folder_name}\tNo SNP detected" >> "$OUTPUT_FILE"
        fi
    else
        echo -e "${folder_name}\tNo tab file  detected" >> "$OUTPUT_FILE"
    fi
done

echo "Compilation complete. Output written to: $OUTPUT_FILE"
