#!/usr/bin/env bash
#SBATCH -J Coord
#SBATCH -p short
#SBATCH --mem=10G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously
#SBATCH -c 10 ###Number of cpus needed for each task

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/CoordinateOfPreAbsGenes.sh ###

set -e


GPA_FILE="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_PG2dSubclade17/Output_98/gene_presence_absence.csv"
GFF_DIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_PG2dSubclade17/Input"
OUTDIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_PG2dSubclade17/Output_98/AccessoryGenes"
GROUP_LIST="${OUTDIR}/target_groups.txt"
MAPPING_CSV="${OUTDIR}/group_gene_map.csv"
OUT_FILE="${OUTDIR}/accessory_gene_coordinates.tsv"


### Step 1: Find GeneID of each group in each genome ###
# === Header for MAPPING_CSV ===
# echo "Group,Genome,GeneID" > "$MAPPING_CSV"
# 
# # === Read column headers from the gene_presence_absence.csv ===
# ### This puts the first line of the CSV (like "Gene","Non-unique Gene name","241211_65x_min_500bp",...) into the variable HEADER_LINE.###
# read -r HEADER_LINE < "$GPA_FILE"
# ### The HEADER array now holds each column name separately ###
# IFS=',' read -ra HEADER <<< "$HEADER_LINE"
# 
# # === Loop through each Panaroo group of interest ===
# while read -r group; do
#     # Find the line in the CSV that matches the group.
#     line=$(grep "^$group," "$GPA_FILE")
# 
#     # Skip if not found
#     [[ -z "$line" ]] && echo "Skipping missing group: $group" && continue
# 
#     # Remove quotes and split into array
#     IFS=',' read -ra FIELDS <<< "$line"
# 
#     # Loop through genome columns (starting at index 2)
#     for ((i = 3; i < ${#HEADER[@]}; i++)); do # skip the the first 3 non-genome metadata columns
#         genome="${HEADER[$i]}"
#         cell="${FIELDS[$i]}"
# 
#         # If the cell has gene IDs (not empty)
#         if [[ -n "$cell" ]]; then
#             # Some cells contain multiple geneIDs separated by semicolons
#             IFS=';' read -ra ID_ARRAY <<< "$cell"
#             for id in "${ID_ARRAY[@]}"; do
#                 trimmed=$(echo "$id" | xargs)
#                 echo "$group,$genome,$trimmed" >> "$MAPPING_CSV"
#             done
#         fi
#     done
# 
# done < "$GROUP_LIST"
# 
# echo "Finished: Mapping saved to $MAPPING_CSV"

### Step 2: Find coordinates of each GeneID in each gff3 file ###

# === OUTPUT HEADER ===
echo -e "Group\tGenome\tGeneID\tContig\tStart\tEnd\tStrand\tProduct" > "$OUT_FILE"

# === PROCESS EACH ENTRY IN THE CSV ===
# Skip header (NR > 1), read columns: group, genome, geneID
tail -n +2 "$MAPPING_CSV" | while IFS=',' read -r group genome geneID; do 

    # Sanity check: skip empty geneIDs
    [[ -z "$geneID" ]] && continue

    # Construct GFF filename for this genome
    gff_file="${GFF_DIR}/${genome}.gff3"

    # Check if the GFF exists
    if [[ ! -f "$gff_file" ]]; then
        echo "Warning: GFF file not found for $genome"
        continue
    fi

    # Grep the line containing the geneID
    # Example GFF line: contig_1 Pyrodigal CDS 314 565 . - 0 ID=LFHGFO_00001;...
    match_line=$(grep -P "\tCDS\t.*ID=${geneID}\b" "$gff_file")

    if [[ -z "$match_line" ]]; then
        echo "Warning: GeneID $geneID not found in $genome" >> "${OUTDIR}/missing_genes.log"
        continue
    fi

    # Parse GFF fields
    contig=$(echo "$match_line" | cut -f1)
    start=$(echo "$match_line" | cut -f4)
    end=$(echo "$match_line" | cut -f5)
    strand=$(echo "$match_line" | cut -f7)

    # Extract 'product=' from attributes
    product=$(echo "$match_line" | grep -oP "product=[^;]+" | cut -d= -f2 || echo "NA")
    # Write to output
    echo -e "${group}\t${genome}\t${geneID}\t${contig}\t${start}\t${end}\t${strand}\t${product}" >> "$OUT_FILE"

done

echo "Extraction complete: $OUT_FILE"
