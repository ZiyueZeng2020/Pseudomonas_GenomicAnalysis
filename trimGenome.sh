#!/usr/bin/env bash
#SBATCH -J trim
#SBATCH --partition=short
#SBATCH --mem=1G
#SBATCH --cpus-per-task=2

#Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/trimGenome.sh

outDir=$1
ForwardReads=$2
ReverseReads=$3

source activate /mnt/shared/scratch/zzeng/apps/conda/envs/trimGalore

    trim_galore \
    --quality 20 \
    --fastqc \
    --output_dir ${outDir} \
    --paired "${ForwardReads}" "${ReverseReads}"

conda deactivate

###FunctionalExample
# outDirMain=/mnt/shared/scratch/zzeng/pseudomonasProject/SeqStrains
# strains=${outDirMain}/Test_2strains
# source activate /mnt/shared/scratch/zzeng/apps/conda/envs/trimGalore
# for x in $(ls ${strains}); do
#     TrimOutDir=${strains}/${x}/trimmedReads_trimGalore/TMPDIR
# 	mkdir -p ${TrimOutDir}
#     cd ${strains}/${x}

#     trim_galore \
#     --quality 13 \
#     --fastqc \
#     --output_dir TrimOutDir=${strains}/${x}/trimmedReads_trimGalore/TMPDIR \
#     ${strains}/${x}/*fastq.gz

    
