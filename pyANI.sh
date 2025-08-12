#!/usr/bin/env bash
#SBATCH -p long
#SBATCH -J pANI
#SBATCH --cpus-per-task=2
#SBATCH --mem=100G
#SBATCH -N 1
#SBATCH --ntasks-per-node=1

#manual -> https://github.com/widdowquinn/pyani/blob/master/README_v_0_2_x.md

###ZZ reminders [Important]:
###❗❗❗Out dir: DO NOT make out dir. The tool makes the out dir. If the out dir exists already, the tool does not work.
###❗❗❗Input formmat: MUST be .fna or other fasta files. Otherwise cannot get all the results.
###❗❗❗In the slurm file, it shows "END" but does not mean the run is done. Need to check the job queue

###💻This script -> sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/pyANI.sh

# Installation
# conda create --name pyani --yes python=3.7
# pip install pyani (had incompatibility issue using conda installation)
# average_nucleotide_identity.py: pyani 0.2.12

source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/pyani

genome_dir=/mnt/shared/scratch/zzeng/pANI/PG2d_Sampling124Agro75Ref100ReSeq1_genomes_wrap
outdir=/mnt/shared/scratch/zzeng/pANI/pANI_PG2d_Sampling124Agro75Ref100Seq1

/mnt/apps/users/zzeng/conda/envs/pyani/bin/average_nucleotide_identity.py \
-i ${genome_dir} \
-g \
--gformat pdf,png,eps \
-o $outdir \
-m ANIm \
-f 