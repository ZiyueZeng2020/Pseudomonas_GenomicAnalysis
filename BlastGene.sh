#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J BlaGene
#SBATCH --mem=5G
#SBATCH -c 10 ###Number of cpus needed for each task

#Real path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/BlastGene.sh

#sets the shell to exit immediately if any command within the script returns a non-zero exit status. It helps in error handling and ensures that the script stops if any part of it fails
set -e

### ZZ reminders: ###
### Need to make dir for blast ###
### -out6 is without headings -out7 is with headings. Need to ues -out6 for JC table summarising scirpt ###

outdir="/mnt/shared/scratch/zzeng/blast/PG2dSubclade17_W3_T3E"
effectors="/mnt/shared/scratch/zzeng/genomes/MH_t3es.fasta"
StrainCollection="/mnt/shared/scratch/zzeng/genomes/fasta_WoodlandPhages"
# RefCollection=/mnt/shared/scratch/zzeng/pseudomonas_genomes/AVpaperPG2_324

mkdir -p "$outdir"

### Step 1: blast ###
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/blast

### If strains are stored in different dir ###
#for x in $(ls ${StrainCollection}/*) $(ls ${RefCollection}/*); do

for x in "${StrainCollection}"/*; do
    if [ ! -f "$x" ]; then
        echo "Warning: $x does not exist. Skipping..."
        continue
    fi

    strain=$(basename "${x%.*}")
    echo "${x}"
    echo "${strain}"

    mkdir -p "${outdir}/database/${strain}"
    mkdir -p "${outdir}/results/${strain}"

    makeblastdb -in "${x}" \
        -parse_seqids \
        -blastdb_version 5 \
        -out "${outdir}/database/${strain}/${strain}" \
        -dbtype nucl 

    tblastn \
        -query "${effectors}" \
        -db "${outdir}/database/${strain}/${strain}" \
        -out "${outdir}/results/${strain}/${strain}_hitable.txt" \
        -evalue 1e-5 \
        -outfmt 6 \
        -max_target_seqs 1 \
        -max_hsps 1 \
        -num_threads "$(nproc)"
done

### Step 2: Make blast summary table ###
# cd ${outdir}/results
# python /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/BlastHitGeneTable.py --path ${outdir}/results

#To blastP: change -dbtype in the line of "makeblastdb" and change "tblastn"
#Need to check -outfmt 6 to obtain heading of the file
# the -out of makeblastdb should be the same as -db of tblastn

#Results layout 
#Fields: query acc.ver, subject acc.ver, % identity, alignment length, mismatches, gap opens, q. start, q. end, s. start, s. end, evalue, bit score