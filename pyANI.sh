#!/usr/bin/env bash
#SBATCH -p long
#SBATCH -J pyani
#SBATCH --cpus-per-task=64
#SBATCH --mem=64G
#SBATCH -N 1 
#SBATCH --ntasks-per-node=1

#manual -> https://github.com/widdowquinn/pyani/blob/master/README_v_0_2_x.md
#This script -> /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/pyANI.sh

export envs=/mnt/shared/scratch/jconnell/apps/miniconda3/envs
source activate ${envs}/pyani2

#Calculate ANI for a set of genome assemblies 

genome_dir=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9
outdir=/mnt/shared/scratch/zzeng/pseudomonasProject/ANI/pANI_ZZtrial

/mnt/shared/scratch/jconnell/apps/miniconda3/envs/pyani/bin/average_nucleotide_identity.py \
-i ${genome_dir} \
-g \
--gformat pdf,png,eps \
-o $outdir \
-m ANIm 
