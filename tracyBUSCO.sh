#!/usr/bin/env bash
#SBATCH -J busco
#SBATCH --partition=short
#SBATCH --mem=4G
#SBATCH --cpus-per-task=8
#SBATCH --output=/dev/null

####Define variables for files required
Assembly=$1
OutDir=$2
####Make output location 
mkdir -p ${OutDir}
####Activate enviroment with dependancies 
export envs=/mnt/shared/scratch/jconnell/apps/miniconda3/envs
source activate ${envs}/busco
####Get only the assembly name and strip file type for results file 
sf=$(basename ${Assembly%.*})
####Copy files to tmpdir for processing 
cp $Assembly ${TMPDIR}/inFile	
cd ${TMPDIR}
####Run busco
busco=/mnt/shared/scratch/jconnell/apps/miniconda3/envs/busco/bin/busco
$busco \
 -i inFile \
 -l /mnt/shared/projects/niab/pseudomonas/busco_db/pseudomonadales_odb10 \
 -m genome \
 -c 8 \
 -o ${sf} 
####Copy files to outdir   
cp -r ${sf} $OutDir



