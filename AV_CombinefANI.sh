#!/bin/bash

# Path of this script: /home/zzeng/git_hub/scripts/pseudomonasAnalysis/AV_CombinefANI.sh

# === CONFIGURATION ===
INPUT_DIR="/mnt/shared/scratch/zzeng/fANI/PG2d_Sampling124Agro75Ref101ReSeq1/out"         # Directory where partition files are located
OUTPUT_FILE="combined_ani_matrix_PG2d301.csv" # Final matrix output
TEMP_COMBINED="temp_combined.csv"     # Temporary file to store combined results

# === Step 1: Combine all FastANI files ===
# You can adjust the pattern (e.g., partition.*) based on your filenames
cat "$INPUT_DIR"/partition.* > "$TEMP_COMBINED"

###NEED TO CHECK THIS PART BEFORE USING IT!!!(copied from ChatGTP, use R script)
# # === Step 2: Generate matrix using AWK ===
# awk '
# BEGIN {
#     FS = OFS = "\t"
# }
# {
#     ani[$1][$2] = $3
#     genomes[$1] = 1
#     genomes[$2] = 1
# }
# END {
#     # Collect and sort genome names
#     for (g in genomes) {
#         header[++n] = g
#     }
#     asort(header)

#     # Write CSV header
#     printf "Genome" > "'"$OUTPUT_FILE"'"
#     for (i = 1; i <= n; i++) {
#         printf ",%s", header[i] >> "'"$OUTPUT_FILE"'"
#     }
#     printf "\n" >> "'"$OUTPUT_FILE"'"

#     # Write each row of the matrix
#     for (i = 1; i <= n; i++) {
#         g1 = header[i]
#         printf "%s", g1 >> "'"$OUTPUT_FILE"'"
#         for (j = 1; j <= n; j++) {
#             g2 = header[j]
#             if (ani[g1][g2] != "") {
#                 printf ",%.2f", ani[g1][g2] >> "'"$OUTPUT_FILE"'"
#             } else if (ani[g2][g1] != "") {
#                 printf ",%.2f", ani[g2][g1] >> "'"$OUTPUT_FILE"'"
#             } else if (g1 == g2) {
#                 printf ",100.00" >> "'"$OUTPUT_FILE"'"
#             } else {
#                 printf ",NA" >> "'"$OUTPUT_FILE"'"
#             }
#         }
#         printf "\n" >> "'"$OUTPUT_FILE"'"
#     }
# }
# ' "$TEMP_COMBINED"

# # === Optional cleanup ===
# rm "$TEMP_COMBINED"

# echo "✅ Combined ANI matrix written to: $OUTPUT_FILE"
