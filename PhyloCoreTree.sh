#!/usr/bin/env bash
#SBATCH -p himem
#SBATCH -J Phy_PG2
#SBATCH --mem=150G
#SBATCH --cpus-per-task=8

#ZZ reminder:
###Merge output files for clustalw was changed!!!
#1. Change ${PhyloTreeOutdir}
#2. Change ${StrainCollection}
#3. Check ${gene} datbase
#4. Check memory
#5. Check CPU

###💻Realpath of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/PhyloCoreTree.sh

#StrainCollection=/mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/Sampling_Ps_QC_PG2bd311
#RefCollection=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref/PG3
PhyloTreeOutdir=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/corePhyloTree/mNGSampPG2bd311PG2ref324PG3ref1

#mkdir -p ${PhyloTreeOutdir}

# ########################################################
# ###### BLASTN housekeeping genes to protein fasta ######
# ########################################################
# blastGene(){
# #for strain in $(ls ${StrainCollection}/*) $(ls ${RefCollection}/*); do
# for strain in $(ls ${RefCollection}/*); do
# 	for gene in $(ls /mnt/shared/scratch/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains/pangenomeHouskeepingGenes/*); do
# 		geneName=$(echo ${gene} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
# 		strainName=$(echo ${strain} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
# 		outdir=${PhyloTreeOutdir}/blastResults/${geneName}
# 		#mkdir -p ${outdir}
# 		cd ${outdir}
# 		while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 150 ]]; do 
# 			sleep 60s
# 		done
# 		echo ${strain}		 
# 		sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/PhyloBlast.sh ${strain} ${gene} ${outdir}
# 	done 
# done
# }
# #🌷🌷🌷
# blastGene
# 
# ###long-1G-4cpu for 1123 strains -> OK

# until [[ $(ls ${PhyloTreeOutdir}/blastResults | wc -l) -eq 842 ]]; do
# 	sleep 60s
# done

# ##############################################
# ###### Merge output files for clustalw  ######
# ##############################################
# concatenate_files(){
# 	mkdir -p ${PhyloTreeOutdir}/mergedHits/${2}
# 	cat ${1} >> ${PhyloTreeOutdir}/mergedHits/${2}/${2}_concatenatedHits.fa
# }

# for gene in $(ls ${PhyloTreeOutdir}/blastResults); do 
# 	blastFiles=${PhyloTreeOutdir}/blastResults/${gene}/*
# 	for y in ${blastFiles}; do
# #🌷🌷🌷
# 		concatenate_files ${y} ${gene}
# 	done
# done

###Need to commentise the for loop, otherwise this section will be running.

# until [[ $(ls ${PhyloTreeOutdir}/mergedHits | wc -l) -eq 842 ]]; do
# 	sleep 60s
# done


#################################
###### Align with clustalW ######
#################################

# AlignWithClustalW(){
# for infile in $(ls ${PhyloTreeOutdir}/mergedHits/*/*); do 
# 	geneName=$(echo ${infile} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
# 	outdir=${PhyloTreeOutdir}/clustalW
# 	mkdir -p ${outdir}
# 	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 30 ]]; do
# 	sleep 20s
# 	done 
# 	sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/PhyloClustaW.sh ${infile} ${outdir} ${geneName}
# done
# }

# 🌷🌷🌷
# AlignWithClustalW


# until [[ $(ls ${PhyloTreeOutdir}/clustalW | wc -l) -eq 842 ]]; do
# 	sleep 60s
# done

# ###############################
# ###### Trim with gblocks ######
# ###############################
# Trim_gblocks(){
#  source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/gblocks 
#  for x in rpoD gltA pgi gyrB acnB; do 
#  outdir=${PhyloTreeOutdir}/gblocks/${x}
#  cd ${PhyloTreeOutdir}/clustalW/${x}
#  mkdir -p ${outdir}
#  Gblocks ${PhyloTreeOutdir}/clustalW/${x}/*renamed.aln -t=d -d=y 
#  mv *.aln-gb* ${outdir}
#  done 
#  conda deactivate
# }
# ###This session caused issue and was not used

# #####################################
# ###### Convert to nexus format ######
# #####################################
# CovertToNexusFormat(){
# source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/bioperl 
# for x in $(ls ${PhyloTreeOutdir}/clustalW/*); do
# 	fileName=$(basename ${x} .aln)
# 	mkdir -p ${PhyloTreeOutdir}/nexus 
# 	perl /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/alignment_convert.pl \
# 	-i ${x} \
# 	-o ${PhyloTreeOutdir}/nexus/${fileName}.nxs \
# 	-f nexus \
# 	-g fasta
# done 
# conda deactivate
# }

# # # # # #🌷🌷🌷 DO NOT run with previous steps, could start too early.
# CovertToNexusFormat

# until [[ $(ls ${PhyloTreeOutdir}/nexus | wc -l) -eq 842 ]]; do
# 	sleep 60s
# done

# cd ${PhyloTreeOutdir}/nexus
# python /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/concatenateNexusAlignment.py ${PWD}

# until [[ $(ls ${PhyloTreeOutdir}/nexus | wc -l) -eq 843 ]]; do
# 	sleep 60s
# done
# ####################
# ###### IQTree ######
# ####################
IQTree(){
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/iqtree 
outdir=${PhyloTreeOutdir}/IQtree
mkdir -p ${outdir}
cp ${PhyloTreeOutdir}/nexus/combined.nex ${outdir}
iqtree -s ${outdir}/combined.nex \
	-bb 1000 \
	-nt AUTO \
	-m GTR+F+I \
	--redo-tree
conda deactivate
}
🌷🌷🌷
IQTree