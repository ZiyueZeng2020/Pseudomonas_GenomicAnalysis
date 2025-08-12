#!/usr/bin/env bash
#SBATCH -J Panqc
#SBATCH -p medium
#SBATCH --mem=20G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously
#SBATCH -c 10 ###Number of cpus needed for each task

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Panqc.sh ###

set -e

### 1) Gene presence absence matrix (As output by Panaroo or Roary) ###
GPA_CSV="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_PG2dSubclade17/Output_98/gene_presence_absence.csv"
### 2) Pan-genome nucleotide reference (As output by Panaroo or Roary) ###
REF_FASTA="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_PG2dSubclade17/Output_98/pan_genome_reference.fa"
### 3) SampleID + Path for all assemblies used in analysis ###
FASTA_DIR="/mnt/shared/scratch/zzeng/genomes/assembly_PG2d_OWsubclade17_31mNG"
STRAIN_PATHS="/mnt/shared/scratch/zzeng/genomes/assembly_PG2d_OWsubclade17_31mNG/InputAsmPaths.tsv"
### 4) OUTDIR ###
OUTDIR="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_PG2dSubclade17/Output_98/Panqc"

# ### Step 1: make out dir ### 
# mkdir -p $OUTDIR 
# 
# ### Step 2: Make input_tsv file from the gene presence absence to ensure correct strains listed ###
# ### Write header (The echo -e command is used in Unix-like shells (e.g., bash) to enable interpretation of backslash-escaped characters in a string (like \n, \t, etc.).) ###
# echo -e "SampleID\tGenome_ASM_PATH" > "$STRAIN_PATHS"
# 
# # Extract strain names from header (skip first 3 columns)
# cut -d',' -f4- "$GPA_CSV" | head -n1 | tr ',' '\n' | while read -r strain; do
#     echo -e "${strain}\t${FASTA_DIR}/${strain}.fa" >> "$STRAIN_PATHS"
# done
# 
# echo "Generated $STRAIN_PATHS"

### Step 3: Run PanQC ---> ###
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/panqc

panqc nrc \
  -a $STRAIN_PATHS \
  -r $REF_FASTA \
  -m $GPA_CSV \
  -o $OUTDIR/
  
  
### Error ###
### echo -e "${strain}\t${FASTA_DIR}/${strain}.fa" >> "$STRAIN_PATHS" ---is the fasta file .fa/.fna/.fasta???