#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J pyani
#SBATCH --cpus-per-task=32
#SBATCH --mem=32G
#SBATCH -N 1 
#SBATCH --ntasks-per-node=1

###Default: Modified p from long to short, cpu from 64 to 32, mem from 64 to 32

#manual -> https://github.com/widdowquinn/pyani/blob/master/README_v_0_2_x.md

#This script -> /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/pyANI.sh

source activate /mnt/shared/scratch/zzeng/apps/conda/envs/pyani_env

#Calculate ANI for a set of genome assemblies 

genome_dir=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9_PG
outdir=/mnt/shared/scratch/zzeng/pseudomonasProject/ANI/pANI_ZZtrial

/mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/average_nucleotide_identity.py \
-i ${genome_dir} \
-g \
--gformat pdf,png,eps \
-o $outdir \
-m ANIm 
