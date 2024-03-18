#!/usr/bin/env bash
#SBATCH -J pangenome
#SBATCH -p short 
#SBATCH --mem=50G
#SBATCH --cpus-per-task=8

#Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/pangenome_geneTable.sh

pangenome_gene(){
# source activate /mnt/shared/scratch/jconnell/apps/miniconda3/envs/prokka 
# for x in $(ls /mnt/shared/scratch/zzeng/pseudomonasProject/SeqStrains/Test_2strains); do 

	analysisDir=/mnt/shared/scratch/zzeng/pseudomonasProject/pangenome/Test_2strains
	genomeAssembly=/mnt/shared/scratch/zzeng/pseudomonasProject/SeqStrains/Test_2strains/${x}/assembly/filtered_contigs/${x}_min_500bp.fasta
	name=$(basename ${genomeAssembly} .fasta)
	# mkdir -p ${analysisDir}/genomes 
    # mkdir -p ${analysisDir}/prokka_annotations/${name} 
    # mkdir -p ${analysisDir}/results 
    
# 	cp ${genomeAssembly} ${analysisDir}/genomes
# 	prokka \
# 	--cpus $(nproc) \
# 	--kingdom Bacteria \
# 	--genus Pseudomonas \
# 	--strain ${name} \
# 	--proteins /mnt/shared/projects/niab/pseudomonas/prokka_protein_db/ps.gbk \
# 	--prefix ${name} \
# 	--outdir ${analysisDir}/prokka_annotations/${name} \
# 	--force \
# 	${genomeAssembly}
# done 
# conda deactivate
 
source activate /mnt/shared/scratch/zzeng/apps/conda/envs/panaroo
for x in $(ls ${analysisDir}/prokka_annotations/*/*.gff); do 
	cp ${x} ${TMPDIR}
done 
cd ${TMPDIR}
panaroo -i *.gff -o results_unmerged --clean-mode strict --remove-invalid-genes
cp -r results_unmerged ${analysisDir}/results
panaroo -i *.gff -o results_merged --clean-mode strict --remove-invalid-genes --merge_paralogs
cp -r results_merged ${analysisDir}/results
}
 
pangenome_gene