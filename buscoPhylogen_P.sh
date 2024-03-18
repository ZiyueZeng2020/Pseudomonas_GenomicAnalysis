#!/usr/bin/env bash 
#SBATCH -p long
#SBATCH -J buscoPhylogeny 
#SBATCH --mem=100G
#SBATCH --cpus-per-task=8
###SBATCH --mail-user=ziyue.zeng@niab.com
###SBATCH --mail-type=END,FAIL

#ZZ reminder: 
#Check 1: busco database in /home/zzeng/git_hub/scripts/pseudomonasAnalysis/tracyBUSCO_P.sh: pseudomonadales_odb10 OR bacteria_odb10
#Check 2: outdir should be /mnt/shared/scratch/${USER}/pseudomonasProject/phylogeny/buscoPhyloTree/XXX (specify genomes).
#Check 3: memory used to be 8G, changed to 64G for running 892ANI ref strains. 
#Check 4: changed cpus to be 8 beacuase phylogeny and IQtree only need 8 threads


#Real path of this script: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/buscoPhylogen_P.sh

####Download strains to be analysed 
export envs=/mnt/shared/scratch/jconnell/apps/miniconda3/envs

# source activate ${envs}/ncbi_datasets
 OutDir=/mnt/shared/scratch/zzeng/pseudomonasProject/phylogeny/buscoPhyloTree/mNGSampling4PG22
# mkdir -p ${OutDir}/genomes
# cd ${OutDir}/genomes
# for x in GCA_000005845.2 GCA_000007805.1 GCA_000012245.1 GCA_000412675.1 GCA_002905685.2 \
# 		 GCA_002905795.2 GCA_002905835.1 GCA_021609785.1 GCA_023278105.1 \
# 		 GCA_000006765.1 GCA_000012265.1 GCA_014839365.1 GCA_015476275.1  \
# 		 GCA_013388375.1 GCA_000156995.2 GCA_002115545.1 GCA_022557255.1 \
# 		 GCA_000452705.3 GCA_000452865.1 GCA_020309905.1 GCA_000452745.3  \
# 		 GCA_023497985.1 GCA_018343775.1 GCA_002905815.2 GCA_021607085.1; do 
# 	datasets download genome accession ${x} 
# 	unzip *.zip 
# 	name=$(cat ncbi_dataset/data/${x}/*.fna | sed -n 1p | awk -v x=${x} '{print $2"_"$3"_"x}')
# 	cp ncbi_dataset/data/${x}/*.fna ./${name}.fna
# 	rm -r *.zip README.md ncbi_dataset
# done 
# cd /home/${USER}
# conda deactivate 

###Run Busco
for x in $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNGSampling4PG22*); do 
mkdir -p ${OutDir}/buscoResults
scriptdir=/home/zzeng/git_hub/scripts/pseudomonasAnalysis
sbatch ${scriptdir}/tracyBUSCO_P.sh ${x} ${OutDir}/buscoResults
done 	

until [[ $(ls /mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/mNGSampling4PG22/* | wc -l) == $(ls ${OutDir}/buscoResults | wc -l) ]]; do
	sleep 60s
done

####Run busco phylogenies 
source activate ${envs}/BUSCO_phylogenomics
python /mnt/shared/scratch/jconnell/pseudomonas_software/buscoPhylogeny/BUSCO_phylogenomics/BUSCO_phylogenomics.py \
-i ${OutDir}/buscoResults \
-o ${OutDir}/phylogenyResults \
--supermatrix_only \
-t 8
conda deactivate 

# ####Create tree 
# source activate ${envs}/iqtree
# cd ${OutDir}/phylogenyResults/supermatrix
# iqtree -s SUPERMATRIX.phylip \
# -bb 1000 \
# -nt 8 \
# -m JTT+I+G \
# -wbtl \
# -safe
# conda deactivate 

#IQ tree setting is copied from MH script https://github.com/michhulin/Pseudomonas/blob/main/scripts/sub_iqtree.sh
