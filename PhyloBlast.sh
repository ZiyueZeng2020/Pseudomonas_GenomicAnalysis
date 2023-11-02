#!/usr/bin/env bash
#SBATCH -p short 
#SBATCH -J phyBlast
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4
#SBATCH --output=/dev/null

#Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/PhyloBlast.sh
 
genome=$1
housegenes=$2
outdir=$3
 
cp ${genome} ${TMPDIR}/nucfile
cp ${housegenes} ${TMPDIR}/hg 
cd ${TMPDIR}
mkdir strainDB
name=$(basename ${genome} | cut -d "_" -f1-2)
str=$(basename ${genome%.*} | cut -d "_" -f3-4)
 
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/blast 
makeblastdb -in nucfile -parse_seqids -blastdb_version 5 -out strainDB/"$name"_db/"$name" -dbtype nucl
blastn -query hg -max_target_seqs 1 -db strainDB/"$name"_db/"$name" -out ./"$name"_hits_table.txt -evalue 1e-5 -outfmt '6 stitle sseq' 
#str=$(less "$name"_hits_table.txt | awk '{print $1"_"$2}')
less "$name"_hits_table.txt | sed 's/[ ,.]//g' | awk -v a=$name -v b=$str '{print ">"a"_"b"\n"$2}' > tmp && mv tmp ${outdir}/"$name"_"$str"_hits_table.txt
conda deactivate 
