#!/usr/bin/env bash 
#SBATCH -p long
#SBATCH -J Coverage
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4
 
### Real path of this script: /home/zzeng/git_hub/scripts/pseudomonasAnalysis/renameContigs.sh

####Strains 
Strains=/mnt/shared/scratch/zzeng/pseudomonasProject/SeqStrains/Test_2strains
###/mnt/shared/projects/niab/pseudomonas/pseudomonasSequencingData_zeng1_to_10_and_1234567p8p10_Wed_18_Oct_2023_14_16_09/241185_248100
calculateCoverage=/home/zzeng/git_hub/scripts/pseudomonasAnalysis/CoverageCalculator_JC.py
filterContigs=/mnt/shared/home/jconnell/git_repos/niab_repos/github_bioinformatics_tools/filterContigs.py

renameContigs(){
for x in $(ls ${Strains}); do
	cd ${Strains}/${x}
	# rm -r assembly/filtered_contigs
	mkdir -p assembly/NEW_filtered_contigs
	cov=$(python ${calculateCoverage} -i *1.fastq.gz *2.fastq.gz -s 6 | sed 's/ coverage//g')
	python /home/zzeng/git_hub/scripts/pseudomonasAnalysis/filterContigs_JC.py \
		--fasta assembly/scaffolds.fasta \
		--minLength 500 \
		--contigName contig
	mv assembly/scaffolds_filtered_contigs_min_500bp.fa assembly/NEW_filtered_contigs/${x}_${cov}_min_500bp.fa 
done 
}

#🌷🌷🌷
#renameContigs