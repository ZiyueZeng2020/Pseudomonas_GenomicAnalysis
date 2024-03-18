#!/usr/bin/env bash
#SBATCH -J SPAdes
#SBATCH --partition=short
#SBATCH --mem=10G
#SBATCH --cpus-per-task=8
#SBATCH --output=/dev/null
 
########################################################################
#Input
# 1st argument: Forward read
# 2nd argument: Reverse read
# 3rd argument: Output directory 
# 4th argument: correction 
# 5th Cutoff
#Output
# Assembly
 
R1=$1
R2=$2
OutDir=$3
Correction=$4
strainName=$5
Cutoff='auto'
F_Read=$(basename $R1)
R_Read=$(basename $R2)
 
cp $R1 $R2 ${TMPDIR}
cd ${TMPDIR}
#Because the reads are copied to the TMPDIR, so basename can be used. Otherwise, full paths need to be provided.

python /mnt/shared/scratch/zzeng/apps/conda/envs/SPAdes-3.15.5-Linux/bin/spades.py -m 200 --phred-offset 33 --careful -1 $F_Read -2 $R_Read -t 30  -o $TMPDIR --cov-cutoff "$Cutoff"
mkdir -p ${TMPDIR}/filtered_contigs
python /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/filter_abyss_contigs.py scaffolds.fasta 500 > filtered_contigs/${strainName}_min_500bp.fasta
 
rm ${F_Read}
rm ${R_Read}
cp -r * ${OutDir}
