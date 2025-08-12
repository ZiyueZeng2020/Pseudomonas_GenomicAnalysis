#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J BlaGene
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/BlastGene_PanarooCheck.sh

### Ensure the script stops on any error ###
set -e

NAMELIST="/mnt/shared/scratch/zzeng/NameList/Pss9644Variants43_reSeq_Long_lost14"
BLAST_DIR="/mnt/shared/scratch/zzeng/blast/PanarooCheck_Pss9644Variants43_reSeq_Long"
PANAROO_REF_FASTA="/mnt/shared/scratch/zzeng/Panaroo/LightDB_PG2d302_Pss9644Variants43ReSeq1Long1/Output98/pan_genome_reference.fa"

## Step 1: Gather target gene sequences ###
## Check if NAMELIST and FASTA exist before running ###
if [ ! -s "$NAMELIST" ]; then
  echo "Error: Name list file $NAMELIST not found or empty!"
  exit 1
fi

if [ ! -s "$PANAROO_REF_FASTA" ]; then
  echo "Error: Panaroo reference FASTA $PANAROO_REF_FASTA not found!"
  exit 1
fi

mkdir -p "$BLAST_DIR"

cd "$BLAST_DIR"
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/seqkit || { echo "Error activating seqkit environment"; exit 1; }

seqkit grep -f "$NAMELIST" "$PANAROO_REF_FASTA" > "Queries_Lost14.fasta"
conda deactivate

### Set paths for BLAST ###
# QUERIES="$BLAST_DIR/Queries.fasta"
# #GENOME="/mnt/shared/scratch/zzeng/genomes/assembly_Pss9644Variants43ReSeq1PG2b1/247868_120x_min_500bp.fa"
# # "/mnt/shared/scratch/zzeng/genomes/pss9644/241643_107x_min_500bp.fa"
# # BLAST_DB_DIR="${BLAST_DIR}/db"
# OUTFILE="Blast_Hit.tsv"
# source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/blast
# 
# ## Step 2: Make a BLAST database from the genome ###
# # echo "Creating BLAST database..."
# # mkdir -p "$BLAST_DB_DIR"
# # 
# # ### For making protein database, using -dbtype prot and blastx in Step2 ###
# # ### For making nucelotide database, using -dbtype nucl and blastn in Step2 ###
# # ### -out "$BLAST_DB_DIR/Pss9644ReSeq_nucl"  Pss9644ReSeq_nucl is the prefix of the db files ###
# # makeblastdb -in "$GENOME" -dbtype nucl -out "$BLAST_DB_DIR/db_file"
# 
# # ### Step 3: Run the BLAST search
# echo "Running BLASTN..."
# cd "$BLAST_DIR"
# ### Need to show prefix of the db files in -db to ensure the files are found ###
# ### blastn for nucl, blastx for protein ###
# blastn -query "$QUERIES" -db "$BLAST_DB_DIR"/db_file -out "$OUTFILE" -outfmt 7

### Use NCBI’s Remote BLAST ###
# blastx -query "$QUERIES" -db nr -remote -out "$OUTFILE" -outfmt 6 -evalue 1e-5
# 
# conda deactivate
# echo "BLAST search complete! Results saved in $OUTFILE"