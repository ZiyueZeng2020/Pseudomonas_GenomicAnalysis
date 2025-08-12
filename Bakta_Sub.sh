#!/usr/bin/env bash
#SBATCH -J subBakta
#SBATCH -p short
#SBATCH --mem=10G
#SBATCH --ntasks=1
#SBATCH -c 6
#SBATCH -o /home/zzeng/slurmFile/slurm-%j.out

# Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Bakta_Sub.sh

set -e
set -x

GENOME="$1"
OUTDIR="$2"
PREFIX="$3"

BB_WORKDIR=$(mktemp -d /mnt/shared/scratch/zzeng/${USER}_${SLURM_JOB_ID}.XXXXXX)
export TMPDIR=${BB_WORKDIR}
export NXF_HOME="/mnt/shared/scratch/zzeng/bakta"

source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/bakta

DB_PATH="/mnt/shared/scratch/zzeng/bakta/bakta_db_light/db-light"
#"/mnt/shared/scratch/zzeng/bakta/bakta_db/db"

bakta --threads "$SLURM_CPUS_PER_TASK" \
      --db "$DB_PATH" \
      --output "$OUTDIR" \
      "$GENOME" \
      --skip-crispr --skip-sorf --skip-pseudo \
      --prefix "$PREFIX"

test -d "$BB_WORKDIR" && rm -rf "$BB_WORKDIR"
