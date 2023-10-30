"#!/usr/bin/env bash
#SBATCH -p long
#SBATCH -J clustalw
#SBATCH --mem=1G
#SBATCH --cpus-per-task=4
#SBATCH --output=/dev/null
 
 
infile=$1
outdir=$2
gene=$3
 
 
cp ${infile} ${TMPDIR}/fastaSeqs
cd ${TMPDIR}
 
source activate clustalW
 
clustalw -infile=fastaSeqs -outfile="$gene"_clustalw.aln -OUTPUT=FASTA
 
cp "$gene"_clustalw.aln ${outdir}
