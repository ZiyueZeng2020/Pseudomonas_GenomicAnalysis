#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J BlastGene
#SBATCH --cpus-per-task=4
#SBATCH --mem=1G


#ZZ reminders:
#Need to make dir for blast 
#-out6 is without headings -out7 is with headings. Need to ues -ou6 for JC table summarising scirpt

#Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/BlastGene.sh

#sets the shell to exit immediately if any command within the script returns a non-zero exit status. It helps in error handling and ensures that the script stops if any part of it fails
set -e

mkdir /mnt/shared/scratch/zzeng/pseudomonasProject/BlastGene/Blast4

source activate blast
outdir=/mnt/shared/scratch/zzeng/pseudomonasProject/BlastGene/Blast4
effectors=/mnt/shared/projects/niab/pseudomonas/michelle_effectors/Pss/attempt1/t3es.fasta
genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9_PG
for x in $(ls ${genome}/*); do
	strain=$(basename ${x} .fna)
	echo ${x}
	echo ${strain}
	mkdir -p ${outdir}/database/${strain}
	mkdir -p ${outdir}/results/${strain}
	makeblastdb -in ${x} -parse_seqids -blastdb_version 5 -out ${outdir}/database/${strain}/${strain} -dbtype nucl 
	tblastn -query ${effectors} -db ${outdir}/database/${strain}/${strain} -out ${outdir}/results/${strain}/${strain}_hitable.txt -evalue 1e-5 -outfmt 6 -num_threads $(nproc)
done

#Make blast summary table
cd ${outdir}/results
python /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/BlastHitGeneTable.py --path ${outdir}/results

#To blastP: change -dbtype in the line of "makeblastdb" and change "tblastn"
#Need to check -outfmt 6 to obtain heading of the file
# the -out of makeblastdb should be the same as -db of tblastn

#Original JC tutorial script:
# source activate blast
# outdir=/mnt/shared/scratch/zzeng/pseudomonasProject/Blast
# effectors=/mnt/shared/projects/niab/pseudomonas/michelle_effectors/Pss/attempt1/t3es.fasta
# genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9_PG
# for x in $(ls ${genome}/*); do
# 	strain=$(basename ${x} .fna)
# 	echo ${strain}
# 	mkdir -p ${outdir}/database/${strain}
# 	mkdir -p ${outdir}/results
# 	makeblastdb -in ${x} -parse_seqids -blastdb_version 5 -out ${outdir}/database/${strain} -dbtype nucl 
# 	tblastn -query ${effectors} -db ${outdir}/database/${strain} -out ${outdir}/results/${strain}_hitable.txt -evalue 1e-5 -outfmt 6 -num_threads $(nproc)
# done


#Results layout 
#Fields: query acc.ver, subject acc.ver, % identity, alignment length, mismatches, gap opens, q. start, q. end, s. start, s. end, evalue, bit score