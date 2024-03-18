#!/usr/bin/env bash
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

