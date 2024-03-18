#!/usr/bin/env bash
#SBATCH -p long
#SBATCH -J clustalw
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --output=/dev/null

#Real path of this script:/mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/PhyloClustaW.sh

infile=$1
outdir=$2
gene=$3
 
 
cp ${infile} ${TMPDIR}/fastaSeqs
cd ${TMPDIR}
 
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/clustalW
 
clustalw -infile=fastaSeqs -outfile="$gene"_clustalw.aln -OUTPUT=FASTA
 
cp "$gene"_clustalw.aln ${outdir}
