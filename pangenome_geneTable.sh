#!/usr/bin/env bash
#SBATCH -J pangenome
#SBATCH -p long 
#SBATCH --mem=5G
#SBATCH --cpus-per-task=4

#Real path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/pangenome_geneTable.sh

source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/panaroo/panaroo

genomeAssembly=/mnt/shared/scratch/zzeng/panaroo/test/genomes
analysisDir=/mnt/shared/scratch/zzeng/panaroo/test

for genomes in ${genomeAssembly}/*.fna; do 
	name=$(basename ${genomes} .fna) # remove extension
    mkdir -p ${analysisDir}/prokka_annotations/${name} 
    mkdir -p ${analysisDir}/results 
    
	prokka \
	--outdir ${analysisDir}/prokka_annotations/${name} \
	--prefix ${name} \
	--kingdom Bacteria \
	--genus Pseudomonas \
	--force \
	${genomes}
done 

# The comments cant be in lines!!
#	--strain ${name} \
#	--proteins /mnt/shared/projects/niab/pseudomonas/prokka_protein_db/ps.gbk \
#	--cpus $(nproc) \

conda deactivate

# source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/panaroo/panaroo
# for x in $(ls ${analysisDir}/prokka_annotations/*/*.gff); do 
# 	cp ${x} ${TMPDIR}
# done 
# cd ${TMPDIR}
# panaroo -i *.gff -o results_unmerged --clean-mode strict --remove-invalid-genes
# cp -r results_unmerged ${analysisDir}/results
# panaroo -i *.gff -o results_merged --clean-mode strict --remove-invalid-genes --merge_paralogs
# cp -r results_merged ${analysisDir}/results
# }
 
# pangenome_gene