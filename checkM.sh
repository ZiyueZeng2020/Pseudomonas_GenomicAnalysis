#!/usr/bin/env bash
#SBATCH -J checkm
#SBATCH --partition=himem
#SBATCH --mem=250G
#SBATCH --cpus-per-task=24


#CheckM Manual: https://github.com/Ecogenomics/CheckM/wiki/Quick-Start#example-usage
#Example usage: "> checkm lineage_wf -t 8 -x fa /home/donovan/bins /home/donovan/checkm"
#Which checkm: /mnt/shared/scratch/zzeng/apps/conda/envs/checkm/bin/checkm
#Help: checkm -h

#ZZ reminder:
#Check ${Genome} 
#Check ${CheckM_Outdir}
#Check input file type. Only the matched files with be processed

#Real path of this script: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/checkM.sh

CheckM_Input=/mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNGAll_fa1797
CheckM_Outdir=/mnt/shared/scratch/zzeng/pseudomonasProject/QC/CheckM/mNGAll_fa1797

mkdir -p ${CheckM_Outdir}

source activate /mnt/shared/scratch/zzeng/apps/conda/envs/checkm

 checkm lineage_wf \
 -t $(nproc) \
 -x .fa \
${CheckM_Input} \
${CheckM_Outdir}

#Installation notes:
#Aside from dependencies, Must download Required reference data and specify where the database is! => "checkm data setRoot /mnt/shared/scratch/zzeng/apps/conda/envs/checkM_database". The alternative method "export CHECKM_DATA_PATH=/path/to/my_checkm_data" did not work!!!
#Check results: bin_stats_ext.tsv (/mnt/shared/scratch/zzeng/pseudomonasProject/QC/CheckM/PG9_test6/results/storage/bin_stats_ext.tsv)