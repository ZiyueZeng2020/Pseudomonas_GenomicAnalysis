#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J fastANI
#SBATCH --cpus-per-task=16
#SBATCH --mem=8G
##SBATCH -- out=/dev/null #Do not generate slurm file, ## make it comment

#-t $(nproc): the number of process = cpus per task
#k for k-mer size
#Need to make a file for the ql or rl to show the real path of all the genomes, using the following codes: "for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref25_PG/*); do echo $x; done  > refgenonmes"
#If there's only one genome, then use -ql real path of the file or -r real path of the file
#If need help, type in "fastANI -h"
#Check whether the tool is ready to use: which fastANI (need to make sure the name of the tool is correct, including cases)
#fastANI => /mnt/shared/scratch/zzeng/apps/conda/envs/pyani_env/bin/fastANI could specify the full path. But after checking "which fastANI", the path of fastANI is set, so only need to use "fastANI" in the first line.

###ZZ reminder[Important]: 
# Input format: ql,rl and -o must ALL be .txt files. If there is only one q or r use -q and -r and make sure the format is .fna
# Input format: When using ql and rl list, genome file name does not have to end with .fna

#Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/fANI.sh

source activate /mnt/shared/scratch/zzeng/apps/conda/envs/pyani_env

fastANI \
-t $(nproc) \
-k 16 \
--ql /mnt/shared/scratch/zzeng/pseudomonas_genomes/refgenonmes_fna.txt \
--rl /mnt/shared/scratch/zzeng/pseudomonas_genomes/refgenonmes.txt \
-o /mnt/shared/scratch/zzeng/pseudomonasProject/ANI/fANI/tiral2.txt

#/mnt/shared/scratch/zzeng/apps/conda/envs/pyani_env/bin/fastANI