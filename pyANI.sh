#!/usr/bin/env bash
#SBATCH -p himem
#SBATCH -J pANIsamp
#SBATCH --cpus-per-task=32
#SBATCH --mem=400G
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

#manual -> https://github.com/widdowquinn/pyani/blob/master/README_v_0_2_x.md

###ZZ reminders [Important]:
###❗❗❗Out dir: DO NOT make out dir. The tool makes the out dir. If the out dir exists already, the tool does not work.
###❗❗❗Input formmat: MUST be .fna or other fasta files. Otherwise cannot get all the results.
###❗❗❗In the slurm file, it shows "END" but does not mean the run is done. Need to check the job queue

###💻This script -> sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/pyANI.sh

source activate /mnt/shared/scratch/zzeng/apps/conda/envs/pyani_env

genome_dir=/mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNGField_Ps267_ANI860_fna_wrap
outdir=/mnt/shared/projects/niab/ZZeng/ANI/mNG/mNGField_Ps267_ANI860_fna_wrap

/mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/average_nucleotide_identity.py \
-i ${genome_dir} \
-g \
--gformat pdf,png,eps \
-o $outdir \
-m ANIm \
-f 

