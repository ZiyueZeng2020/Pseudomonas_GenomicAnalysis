#!/usr/bin/env bash
#SBATCH -J ExtractFasta
#SBATCH -p medium 
#SBATCH --mem=5G
#SBATCH -c 2 ###Number of cpus needed for each task

### Realpath of this file: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/ExtractFastaBasedOnCoordinates.sh ###

### Requirement of bed file:
### Column 1 (fasata name) matches the FASTA header.
### Column 2 (start) is 0-based (you subtracted 1 from the original start). So the start need to be manually reduced by 1
### Tab-separated. The bed file can be made in Excel and saved as txt (sep by tab). And renamed as .bed
### Headers of each extracted fasta in column 4.

### Check before running the script.......
head -n 1 $BEDFILE | cat -A ### Prints the first line and "cat -A" shows all normally-invisible characters: tabs appear as ^I, line-ends as $, carriage returns as ^M, non-ASCII bytes as M-…, etc.

set -e

# Input files
GENOME="/mnt/shared/scratch/zzeng/genomes/fasta_WoodlandPhages/241211_Phi1.fasta"
OUTDIR="/mnt/shared/scratch/zzeng/genomes/fasta_WoodlandPhages/ExtractedFasta"
BEDFILE="$OUTDIR/Phi241211_3Wgenes38_coordinates.bed"
OUTPUT="$OUTDIR/241211Phi1_Wgenes49.fasta"

cd "$OUTDIR"
# Extract sequences
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/snippy

bedtools getfasta -fi "$GENOME" -bed "$BEDFILE" -fo "$OUTPUT" -name

echo "Sequences extracted to $OUTPUT"