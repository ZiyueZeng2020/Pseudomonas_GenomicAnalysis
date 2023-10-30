"#!/usr/bin/env bash
#SBATCH -p long
#SBATCH -J phylogeny
#SBATCH --mem=150G
#SBATCH --cpus-per-task=8
 
####Create phylogeny from all single copy core genes for DC3000 GCA_000007805.1
 
####Download CDS for all pangenome strains 	
# source activate ncbi_datasets
# cd /home/jconnell/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains
# for x in GCA_002905795.2 GCA_002905875.2 GCA_023278105.1 GCA_000012265.1 GCA_000007805.1; do 
# 	datasets download genome accession ${x} --include cds
# 	unzip *.zip 
# 	cp ncbi_dataset/data/${x}/* ./${x}.fasta
# 	rm -r *.zip README.md ncbi_dataset
# done 
# conda deactivate
 
# ####Identify all single copy core protsins in DC3000 
# /home/jconnell/jconnell/pseudomonas_software/software/OrthoFinder/orthofinder \
# -d \
# -f /home/jconnell/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains \
# -o /home/jconnell/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains/results  
 
####Create list of the single copy core gene sequences from a strain here DC3000 for later blast in query strains 
# DC3000GFF=/mnt/shared/scratch/jconnell/pseudomonasProject/houseKeepingGenes/ncbi_dataset/data/GCA_000007805.1/genomic.gff
# DC3000FNA=/mnt/shared/scratch/jconnell/pseudomonasProject/houseKeepingGenes/ncbi_dataset/data/GCA_000007805.1/GCA_000007805.1_ASM780v1_genomic.fna
# coreGeneFasta=/home/jconnell/jconnell/pseudomonasProject/houseKeepingGenes/pangenomeHouskeepingGenes
# for x in $(ls /home/jconnell/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains/results/Results_Aug11/Single_Copy_Orthologue_Sequences/*); do 
# 	i=$(cat ${x} | grep ">" | awk '{print length, $0}' | sort -nr  | head -n 1 | cut -d " " -f2)
# 	if  echo ${i} | grep -q -w "gene" ; then
# 		gene=$(echo ${i} | grep -o 'gene=[^]]*' | cut -d "=" -f2)
# 		pos=$(cat ${DC3000GFF} | grep ${gene} | grep -w "gene" | head -n 1 | awk '{print $4"-"$5}')
# 		samtools faidx ${DC3000FNA} chromosome1:$(echo ${pos} | cut -d "-" -f1)-$(echo ${pos} | cut -d "-" -f2) >> ${coreGeneFasta}/${gene}_fasta.txt	
# 		sed -i "s|>chromosome1:$(echo ${pos} | cut -d "-" -f1)-$(echo ${pos} | cut -d "-" -f2)|>${gene}|g" ${coreGeneFasta}/${gene}_fasta.txt
# 	fi	
# done
 
####BLASTN housekeeping genes to protein fasta 
for strain in $(ls /home/jconnell/jconnell/pseudomonasProject/MNGTree/assemblys/*); do
	for gene in $(ls /home/jconnell/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains/pangenomeHouskeepingGenes/*); do
		geneName=$(echo ${gene} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
		strainName=$(echo ${strain} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
		outdir=/home/jconnell/jconnell/pseudomonasProject/MNGTree/blastResults/${geneName}
		mkdir -p ${outdir}
		scriptdir=/home/jconnell/git_repos/niab_repos/pseudomonas_analysis/Phylogeny
		while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 150 ]]; do 
			sleep 1
		done 
		sbatch $scriptdir/pangenomePhylogenyBlastN.sh ${strain} ${gene} ${outdir}
	done 
done
 
####Merge output files for clustalw 
concatenate_files() {
	mkdir -p /home/jconnell/jconnell/pseudomonasProject/MNGTree/mergedHits/${2}
	cat ${1} >> /home/jconnell/jconnell/pseudomonasProject/MNGTree/mergedHits/${2}/${2}_concatenatedHits.fa
}
for gene in $(ls /home/jconnell/jconnell/pseudomonasProject/MNGTree/blastResults); do 
	blastFiles=/home/jconnell/jconnell/pseudomonasProject/MNGTree/blastResults/${gene}/*
	for y in ${blastFiles}; do
		concatenate_files ${y} ${gene}
	done
done
 
####Align with clustalW
for infile in $(ls /home/jconnell/jconnell/pseudomonasProject/MNGTree/mergedHits/*/*); do 
	geneName=$(echo ${infile} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
	outdir=/home/jconnell/jconnell/pseudomonasProject/MNGTree/clustalW
	mkdir -p ${outdir}
	progdir=/home/jconnell/git_repos/niab_repos/pseudomonas_analysis/Phylogeny
	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 30 ]]; do
	sleep 20s
	done 
	sbatch ${progdir}/phylogenyClustalw.sh ${infile} ${outdir} ${geneName}
done
 
####Trim with gblocks 
# source activate gblocks 
# for x in rpoD gltA pgi gyrB acnB; do 
# outdir=/home/jconnell/jconnell/pseudomonasProject/redo/gblocks/${x}
# cd /home/jconnell/jconnell/pseudomonasProject/redo/clustalW/${x}
# mkdir -p ${outdir}
# Gblocks /home/jconnell/jconnell/pseudomonasProject/redo/clustalW/${x}/*renamed.aln -t=d -d=y 
# mv *.aln-gb* ${outdir}
# done 
# conda deactivate
 
###Convert to nexus format 
source activate bioperl 
for x in $(ls /home/jconnell/jconnell/pseudomonasProject/MNGTree/clustalW/*); do
	fileName=$(basename ${x} .aln)
	mkdir -p /home/jconnell/jconnell/pseudomonasProject/MNGTree/nexus 
	perl /home/jconnell/git_repos/niab_repos/pseudomonas_analysis/Phylogeny/alignment_convert.pl \
	-i ${x} \
	-o /home/jconnell/jconnell/pseudomonasProject/MNGTree/nexus/${fileName}.nxs \
	-f nexus \
	-g fasta
done 
conda deactivate
 
cd /home/jconnell/jconnell/pseudomonasProject/MNGTree/nexus
python /home/jconnell/git_repos/niab_repos/pseudomonas_analysis/Phylogeny/concatenateNexusAlignment.py ${PWD}
 
# ####IQTree
source activate iqtree 
outdir=/home/jconnell/jconnell/pseudomonasProject/MNGTree/IQtree
#mkdir -p ${outdir}
#cp /mnt/shared/scratch/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains/nexus/combined.nex ${outdir}
iqtree -s ${outdir}/combined.nex \
	-bb 1000 \
	-m GTR+I+G \
	-nt AUTO \
	--redo-tree
conda deactivate"
