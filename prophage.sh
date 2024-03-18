#!/usr/bin/env bash
#SBATCH -p short 
#SBATCH -J ProVP 
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4

#ZZ reminder:
#If the folder of outdir is there already, the results cannot be added in. Need to make sure there is no existed folder
#Change ${genomeToCheck}
#Change ${ResultsFolder}
#Realpath of this script: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/prophage.sh

 genomeToCheck=/mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/test
 ResultsFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/prophage/mNG_test

# genomeToCheck=/mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNGAll_fa1797
# ResultsFolder=/mnt/shared/scratch/zzeng/pseudomonasProject/prophage/mNGAll1797

runVibrant(){
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/vibrant 
for x in $(ls ${genomeToCheck}/*); do
	name=$(basename ${x} .fa)
	outDir=${ResultsFolder}/vibrant/${name}
	mkdir -p ${outDir}
	cd ${outDir}
	while [ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]; do
    	sleep 60s
  	done
	python /mnt/shared/scratch/jconnell/vibrant/VIBRANT/VIBRANT_run.py -i ${x}
done 
conda deactivate 
}

#🌷🌷🌷
#runVibrant

prokka(){
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/roary
export PATH="$PATH:/mnt/shared/scratch/jconnell/apps/miniconda3/pkgs/mcl-14.137-h470a237_3/bin"
find "${genomeToCheck}" -type f -name '*.fa' -print0 | while IFS= read -r -d $'\0' x; do
	name=$(basename ${x} .fa)
	outDir=${ResultsFolder}/PhiSpy/${name}
	mkdir -p ${outDir}
	while [ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]; do
    	sleep 60s
  	done
	prokka \
		--kingdom Bacteria \
		--outdir ${outDir}/prokka \
		--genus Pseudomonas \
		--locustag ${name} \
		--prefix ${name} \
		${x}
done
conda deactivate
}

#🌷🌷🌷
prokka

runPhiSpy(){
source activate /mnt/shared/scratch/zzeng/apps/conda/envs/phispy 
for x in $(ls ${genomeToCheck}/*); do
	name=$(basename ${x} .fa)
	outDir=${ResultsFolder}/PhiSpy/${name}
	while [ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]; do
    	sleep 60s
  	done
PhiSpy.py ${outDir}/prokka/${name}.gbk -o ${outDir} 
done 
conda deactivate 
}


#🌷🌷🌷
#runPhiSpy	


##usful files
#[results folder]VIBRANT_integrated_prophage_coordinates_GCA_002905685.2_PsmR15244_PG3.tsv (coordinates)
#[results folder]VIBRANT_genbank_table_GCA_002905685.2_PsmR15244_PG3.tsv (CDS)
#[phage folder]GCA_002905685.2_PsmR15244_PG3.phages_lysogenic.fna (pahge sequence)
#[phage folder]GCA_002905685.2_PsmR15244_PG3.phages_combined.txt (number of phages)

#### PhiSpy 
# Manual: https://pypi.org/project/PhiSpy/

# Output format:
# The id of each gene;
# function: function of the gene (or product from a GenBank file);
# contig;
# start: start location of the gene;
# stop: end location of the gene;
# position: a sequential number of the gene (starting at 1);
# rank: rank of each gene provided by random forest;
# my_status: status of each gene based on random forest;
# pp: classification of each gene based on their function;
# Final_status: the status of each gene. For prophages, this column has the number of the prophage as listed in prophage.tbl above; If the column contains a 0 we believe that it is a bacterial gene. Otherwise we believe that it is possibly a phage gene.

# --output_choice 8
##########################################################################
