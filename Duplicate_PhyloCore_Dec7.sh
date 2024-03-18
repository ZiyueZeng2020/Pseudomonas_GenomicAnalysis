#!/usr/bin/env bash
#SBATCH -p himem
#SBATCH -J coPhyANI
#SBATCH --mem=150G
#SBATCH --cpus-per-task=16

#ZZ reminder:
###Merge output files for clustalw was changed!!!
#1. Change ${PhyloTreeOutdir}
#2. Change ${StrainCollection}
#3. Check ${gene} datbase
#4. Check memory
#5. Check CPU

#Realpath of this script: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/Duplicate_PhyloCore_Dec7.sh

###MakeCoreGenomePhyloTree
StrainCollection=/home/zzeng/scratch/pseudomonas_genomes/ANIref836Ref22_Uniq844
PhyloTreeOutdir=/home/zzeng/scratch/pseudomonasProject/phylogeny/corePhyloTree/ANIref836Ref22_Uniq844_New

#mkdir -p ${PhyloTreeOutdir}

##MakeCoreGenomePhyloTree
##BLASTN housekeeping genes to protein fasta 
# for strain in $(ls ${StrainCollection}/*); do
# 	for gene in $(ls /mnt/shared/scratch/jconnell/pseudomonasProject/ampliconPhylogeny/pangenomeStrains/pangenomeHouskeepingGenes/*); do
# 		geneName=$(echo ${gene} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
# 		strainName=$(echo ${strain} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
# 		outdir=${PhyloTreeOutdir}/blastResults/${geneName}
# 		mkdir -p ${outdir}
# 		#scriptdir=/home/jconnell/git_repos/niab_repos/pseudomonas_analysis/Phylogeny #No need to use JC scirptdir as all the scripts are copied to zzeng github
# 		while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 150 ]]; do 
# 			sleep 1
# 		done
# 		echo ${strain}		 
# 		sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/PhyloBlast.sh ${strain} ${gene} ${outdir}
# 	done 
# done

##Merge output files for clustalw 
##Short-1G-1cpu for 844 strains -> OK
concatenate_files() {
	mkdir -p ${PhyloTreeOutdir}/mergedHits/${2}
	cat ${1} >> ${PhyloTreeOutdir}/mergedHits/${2}/${2}_concatenatedHits.fa
}
for gene in $(ls /mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/corePhyloTree/ANIref836Ref22_Uniq844/blastResults); do 
	blastFiles=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/corePhyloTree/ANIref836Ref22_Uniq844/blastResults/${gene}/*
	for y in ${blastFiles}; do
		concatenate_files ${y} ${gene}
	done
done
 
###Align with clustalW
for infile in $(ls ${PhyloTreeOutdir}/mergedHits/*/*); do 
	geneName=$(echo ${infile} | rev | cut -d "/" -f1 | rev | cut -d "_" -f1)
	outdir=${PhyloTreeOutdir}/clustalW
	mkdir -p ${outdir}
	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 30 ]]; do
	sleep 20s
	done 
	sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/PhyloClustaW.sh ${infile} ${outdir} ${geneName}
done
 
####Trim with gblocks 
 # source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/gblocks 
 # for x in rpoD gltA pgi gyrB acnB; do 
 # outdir=${PhyloTreeOutdir}/gblocks/${x}
 # cd ${PhyloTreeOutdir}/clustalW/${x}
 # mkdir -p ${outdir}
 # Gblocks ${PhyloTreeOutdir}/clustalW/${x}/*renamed.aln -t=d -d=y 
 # mv *.aln-gb* ${outdir}
 # done 
 # conda deactivate
 
##Convert to nexus format 
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/bioperl 
for x in $(ls ${PhyloTreeOutdir}/clustalW/*); do
	fileName=$(basename ${x} .aln)
	mkdir -p ${PhyloTreeOutdir}/nexus 
	perl /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/alignment_convert.pl \
	-i ${x} \
	-o ${PhyloTreeOutdir}/nexus/${fileName}.nxs \
	-f nexus \
	-g fasta
done 
conda deactivate
 
cd ${PhyloTreeOutdir}/nexus
python /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/concatenateNexusAlignment.py ${PWD}

# #####IQTree
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/iqtree 
outdir=${PhyloTreeOutdir}/IQtree
mkdir -p ${outdir}
cp ${PhyloTreeOutdir}/nexus/combined.nex ${outdir}
iqtree -s ${outdir}/combined.nex \
	-bb 1000 \
	-m GTR+I+G \
	-nt AUTO \
	--redo-tree
conda deactivate