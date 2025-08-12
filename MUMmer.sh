#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J MUMmer
#SBATCH --cpus-per-task=1
#SBATCH --mem=5G

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/MUMmer.sh

### Reminder: This script needs to be bashed/sbatched in the folder where the ref and query genomes are! Otherwise need to specify the paths of the files!

# === Set paths ===
REF="241643_107x_min_500bp.fa"
QUERY="247903_74x_min_500bp.fa"
PREFIX="pss_alignment"

# === Print status ===
echo "Running MUMmer alignment..."
echo "Reference: $REF"
echo "Query: $QUERY"
echo "Prefix: $PREFIX"

# === Run nucmer ===
nucmer --prefix=$PREFIX $REF $QUERY

# === Filter best alignments ===
delta-filter -1 ${PREFIX}.delta > ${PREFIX}.filtered.delta

# === Generate readable coordinates ===
show-coords -rcl ${PREFIX}.filtered.delta > ${PREFIX}.coords

# === Optional: generate dotplot === Does not work at the moment because the software cannot be installed.
#mummerplot --png --layout -p ${PREFIX}_plot ${PREFIX}.filtered.delta

# === Summary of where the SNPs are ===
/home/zzeng/scratch/env/mummer-4.0.0beta2/dnadiff -p dnadiff_output $REF $QUERY
### If get error "bash: dnadiff: command not found", then "find ~/scratch/env/mummer* -type f -name dnadiff" and update the path 

# === Done ===
echo "MUMmer analysis complete!"
echo "Output files:"
echo "- ${PREFIX}.delta"
echo "- ${PREFIX}.filtered.delta"
echo "- ${PREFIX}.coords"
echo "- ${PREFIX}_SNP summary"
