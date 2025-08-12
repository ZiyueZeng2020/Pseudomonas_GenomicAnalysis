#!/usr/bin/env bash
#SBATCH -p medium
#SBATCH -J fANI            # Job name
#SBATCH --mem=4G           # Memory
#SBATCH -c 2                # 2 CPU cores

# Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/AV_fANI.sh

source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/pyani

fastANI --ql "$1" --rl "$2" -o "$3"



