#!/usr/bin/env bash
#SBATCH -J Decompress
#SBATCH -p long
#SBATCH --mem=50G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously
#SBATCH -c 10 ###Number of cpus needed for each task

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/DecompressTo.sh
# Define source and target paths
SOURCE_ARCHIVE="/mnt/shared/projects/niab/pseudomonas/pseudomonasProjectArchive.tar.gz"
TARGET_DIR="/mnt/apps/users/zzeng/archive"

# Create the target directory if it doesn't exist
# mkdir -p "$TARGET_DIR"

# Change to the target directory
cd "$TARGET_DIR" || { echo "Failed to enter $TARGET_DIR"; exit 1; }

# Extract the archive into the target directory
tar -xzf "$SOURCE_ARCHIVE"

echo "Extraction completed successfully to $TARGET_DIR"
