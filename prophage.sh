#!/usr/bin/env bash
#SBATCH -p long 
#SBATCH -J ProVP 
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4

#Realpath of this script /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/prophage.sh
 
# runVibrant(){
# source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/vibrant 
# for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9_PG/*); do
# 	name=$(basename ${x} .fa)
# 	outDir=/mnt/shared/scratch/zzeng/pseudomonasProject/prophageVP/vibrant/${name}
# 	mkdir -p ${outDir}
# 	cd ${outDir}
# 	python /mnt/shared/scratch/jconnell/vibrant/VIBRANT/VIBRANT_run.py -i ${x}
# done 
# conda deactivate 
# }
 
runPhiSpy(){
for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9_PG/*); do
source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/roary
export PATH="$PATH:/mnt/shared/home/jconnell/miniconda3/pkgs/mcl-14.137-h470a237_3/bin"
	name=$(basename ${x} .fa)
	outDir=/mnt/shared/scratch/zzeng/pseudomonasProject/prophageVP/PhiSpy/${name}
	mkdir -p ${outDir}
	prokka \
		--kingdom Bacteria \
		--outdir ${outDir}/prokka \
		--genus Pseudomonas \
		--locustag ${name} \
		--prefix ${name} \
		${x}
conda deactivate 

source activate /mnt/shared/scratch/zzeng/apps/conda/envs/phispy 
PhiSpy.py ${outDir}/prokka/${name}.gbk -o ${outDir} 
conda deactivate 
done 
}
 
 
runPhiSpy	
#runVibrant


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
# Original JC script:
# #!/usr/bin/env bash
# #SBATCH -p long 
# #SBATCH -J vibrant 
# #SBATCH --mem=10G
# #SBATCH --cpus-per-task=4
 
# runVibrant(){
# source activate vibrant 
# for x in $(ls /mnt/shared/scratch/jconnell/pseudomonasProject/vibrant_phispy/genomes/*); do
# 	name=$(basename ${x} .fa)
# 	outDir=/mnt/shared/scratch/jconnell/pseudomonasProject/vibrant_phispy/vibrant/${name}
# 	mkdir -p ${outDir}
# 	cd ${outDir}
# 	python /mnt/shared/scratch/jconnell/vibrant/VIBRANT/VIBRANT_run.py -i ${x}
# done 
# conda deactivate 
# }
 
# runPhiSpy(){
# source activate roary
# export PATH="$PATH:/home/jconnell/miniconda3/pkgs/mcl-14.137-h470a237_3/bin"
# for x in $(ls /mnt/shared/scratch/jconnell/pseudomonasProject/vibrant_phispy/genomes/*); do
# 	name=$(basename ${x} .fa)
# 	outDir=/mnt/shared/scratch/jconnell/pseudomonasProject/vibrant_phispy/PhiSpy/${name}
# 	mkdir -p ${outDir}
# 	prokka \
# 		--kingdom Bacteria \
# 		--outdir ${outDir}/prokka \
# 		--genus Pseudomonas \
# 		--locustag ${name} \
# 		--prefix ${name} \
# 		${x}
# conda deactivate 
# source activate phispy 
# PhiSpy.py -o ${outDir} ${outDir}/prokka/${name}.gbk
# conda deactivate 
# done 
# }
 
 
# runPhiSpy	
runVibrant