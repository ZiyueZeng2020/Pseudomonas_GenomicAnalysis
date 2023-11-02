#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J BlastGene
#SBATCH --cpus-per-task=4
#SBATCH --mem=1G

#Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/BlastGene.sh

source activate blast
outdir=/mnt/shared/scratch/zzeng/pseudomonasProject/Blast
effectors=/mnt/shared/projects/niab/pseudomonas/michelle_effectors/Pss/attempt1/t3es.fasta
genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9_PG
for x in $(ls ${genome}/*); do
	strain=$(basename ${x} .fna)
	echo ${strain}
	mkdir -p ${outdir}/database/${strain}
	mkdir -p ${outdir}/results
	makeblastdb -in ${x} -parse_seqids -blastdb_version 5 -out ${outdir}/database/${strain} -dbtype nucl 
	tblastn -query ${effectors} -db ${outdir}/database/${strain} -out ${outdir}/results/${strain}_hitable.txt -evalue 1e-5 -outfmt 6 -num_threads $(nproc)
done

#To blastP: change -dbtype in the line of "makeblastdb" and change "tblastn"
#Need to check -outfmt 6 to obtain heading of the file
# the -out of makeblastdb should be the same as -db of tblastn