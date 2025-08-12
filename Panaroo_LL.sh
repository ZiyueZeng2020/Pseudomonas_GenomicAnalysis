#!/usr/bin/env bash
#SBATCH -J Panaroo
#SBATCH -p long
#SBATCH --mem=50G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously
#SBATCH -c 50  ###Number of cpus needed for each task

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Panaroo_LL.sh ###

### Create a temporary working directory on the scratch space ###
BB_WORKDIR=$(mktemp -d /mnt/shared/scratch/zzeng/${USER}_${SLURM_JOBID}.XXXXXX)
export TMPDIR=${BB_WORKDIR}

### Ensure the script stops on any error ###
set -e

source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/panaroo

### Set paths ###
BAKTA_OUTPUT_DIR="/mnt/shared/scratch/zzeng/bakta/LightDB_AllSeq1797R39_compliant"  
PANAROO_INPUT_DIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2bd_PT2021_149_PG1/Input"
PANAROO_OUTPUT_DIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2bd_PT2021_149_PG1/Output98"
GENOME_LIST="/mnt/shared/scratch/zzeng/NameList/PG2bd_PT2021_149_PG1"

# ### Step 1: Copy .gff3 and .fna files for genomes on the list ###
# mkdir -p $PANAROO_INPUT_DIR
# 
# while read -r pattern; do
#   # Find directories matching the internal ID pattern
#   matches=$(find "$BAKTA_OUTPUT_DIR" -maxdepth 1 -type d -name "*${pattern}*")
# 
#   if [[ -z "$matches" ]]; then
#     echo "No directory found matching pattern: $pattern"
#     continue
#   fi
# 
#   for dir in $matches; do
#     # Try to find GCA_* files inside the matched directory
#     gff_path=$(find "$dir" -type f -name "*.gff3" | head -n 1)
#     fna_path=$(find "$dir" -type f -name "*.fna" | head -n 1)
# 
#     if [[ -f "$gff_path" ]]; then
#       cp "$gff_path" "$PANAROO_INPUT_DIR"
#       echo "Copied: $(basename "$gff_path")"
#     else
#       echo "Missing: GFF file in $dir"
#     fi
# 
#     if [[ -f "$fna_path" ]]; then
#       cp "$fna_path" "$PANAROO_INPUT_DIR"
#       echo "Copied: $(basename "$fna_path")"
#     else
#       echo "Missing: FNA file in $dir"
#     fi
#   done
# done < "$GENOME_LIST"

### Step 2: Make input file ###
# cd "$PANAROO_INPUT_DIR"
# 
# ls *.gff3 | while read -r gff; do
#     base=$(basename "$gff" .gff3)
#     gff_path="$PANAROO_INPUT_DIR/${base}.gff3"
#     fna_path="$PANAROO_INPUT_DIR/${base}.fna"
#     
#     if [[ -f "$fna_path" ]]; then
#         echo "$gff_path	$fna_path"
#     else
#         echo "Warning: missing $fna_path" >&2
#     fi
# done > panaroo_input.txt

### Step 3: Run Panaroo ###
mkdir -p $PANAROO_OUTPUT_DIR

echo "Running Panaroo..."
panaroo \
-i "${PANAROO_INPUT_DIR}"/panaroo_input.txt \
-o $PANAROO_OUTPUT_DIR \
--clean-mode strict \
--merge_paralogs \
--aligner mafft \
-c 0.98 \
--len_dif_percent 0.98 \
-a pan \
--core_threshold 0.98 \
-t 50 \
--remove-invalid-genes

### -c 0.98 Clustering threshold. Defines the sequence identity for clustering genes into gene families. Genes sharing ≥98% sequence identity are grouped together. ###
### --len_dif_percent 0.98 For clustering genes. This sets the  maximum allowed difference in gene length (as a fraction) between homologous genes during clustering. ###
### --core_threshold 0.98 Core genome definition. A gene is considered core if it is found in ≥98% of genomes ###
### -f 0.5 Amino acid identity threshold for grouping gene families ###

### Check for completion ###
if [ $? -eq 0 ]; then
    echo "Panaroo completed successfully! Results are in $PANAROO_OUTPUT_DIR"
else
    echo "Panaroo encountered an error. Check the log for details."
    exit 1
fi

test -d ${BB_WORKDIR} && /bin/rm -rf ${BB_WORKDIR}
