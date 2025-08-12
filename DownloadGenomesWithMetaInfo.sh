#!/bin/bash
#SBATCH -J DownGenome
#SBATCH -p short
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4

# Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/DownloadGenomesWithMetaInfo.sh

input_file="/home/zzeng/scratch/NameList/PG2dRef"
output_dir="/mnt/shared/scratch/zzeng/ref_PG2d"

mkdir -p "$output_dir"

while read -r acc; do
    [ -z "$acc" ] && continue
    echo "🔽 Processing $acc..."

    cd "$output_dir"

    # Download genome (includes metadata by default)
    datasets download genome accession "$acc"

    # Check if download succeeded
    if [[ ! -f ncbi_dataset.zip ]]; then
        echo "⚠️  Failed to download $acc"
        continue
    fi

    # Unzip contents
    unzip -o ncbi_dataset.zip

    # Copy .fna file
    cp ncbi_dataset/data/${acc}.*/*.fna ./

    # Extract structured metadata (TSV)
    dataformat tsv genome --package ncbi_dataset.zip > "${acc}_metadata.tsv"

    # Clean up
    rm -rf ncbi_dataset.zip ncbi_dataset README.md

done < "$input_file"
