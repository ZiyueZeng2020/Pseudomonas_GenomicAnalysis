#!/usr/bin/env bash 
#SBATCH -p long
#SBATCH -J buscoPhylogeny 
#SBATCH --mem=8G
#SBATCH --cpus-per-task=64
#SBATCH --mail-user=ziyue.zeng@niab.com
#SBATCH --mail-type=BEGIN,END,FAIL

####Download strains to be analysed 
####Edit for Tracys use 
export envs=/mnt/shared/scratch/jconnell/apps/miniconda3/envs
OutDir=/mnt/shared/scratch/${USER}/pseudomonasProject/phylogeny
mkdir -p ${OutDir}/ZZbuscoPhylogeny

###Copy genomes to be used
#cp -r /mnt/shared/scratch/zzeng/pseudomonas_genomes/* /mnt/shared/scratch/${USER}/pseudomonasProject/phylogeny/ZZbuscoPhylogeny

####Run Busco
for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/*.fna); do 
mkdir -p ${OutDir}/ZZbuscoPhylogeny/buscoResults
scriptdir=/home/zzeng/git_hub/scripts/pseudomonasAnalysis
sbatch ${scriptdir}/tracyBUSCO.sh ${x} ${OutDir}/ZZbuscoPhylogeny/buscoResults
done 	

until [[ $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/*.fna | wc -l) == $(ls ${OutDir}/ZZbuscoPhylogeny/buscoResults | wc -l) ]]; do
	sleep 60s
done

####Run busco phylogenies 
source activate ${envs}/BUSCO_phylogenomics
python /mnt/shared/scratch/jconnell/pseudomonas_software/buscoPhylogeny/BUSCO_phylogenomics/BUSCO_phylogenomics.py \
-i ${OutDir}/ZZbuscoPhylogeny/buscoResults \
-o ${OutDir}/ZZbuscoPhylogeny/phylogenyResults \
--supermatrix_only \
-t 8
conda deactivate 

####Create tree 
source activate ${envs}/iqtree
cd ${OutDir}/ZZbuscoPhylogeny/phylogenyResults/supermatrix
iqtree -s SUPERMATRIX.phylip \
-bb 1000 \
#-nt 8
conda deactivate
