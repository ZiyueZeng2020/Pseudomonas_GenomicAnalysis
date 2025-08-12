#!/usr/bin/env bash
#SBATCH -J Snippy
#SBATCH -p medium
#SBATCH --mem=20G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously
#SBATCH -c 8 ###Number of cpus needed for each task

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Snippy.sh
set -e

BB_WORKDIR=$(mktemp -d /mnt/shared/scratch/zzeng/${USER}_${SLURM_JOBID}.XXXXXX)
export TMPDIR=${BB_WORKDIR}

INPATH="/mnt/shared/scratch/zzeng/genomes/readT_PG2d_OWsubclade17_31mNG"
### GenBank file downloaded from BenBank caused error, need fasta file as reference. Bakta annotated gbff file works ###
REF_GENOME="/mnt/shared/scratch/zzeng/bakta/results_ref39/GCA_002905815/GCA_002905815.gbff"
#"/mnt/shared/scratch/zzeng/bakta/results_Pss9644_longReSeq/241643_107x_min_500bp/241643_107x_min_500bp.gbff"
# "/mnt/shared/scratch/zzeng/bakta/results_Pss9644_longReSeq/Pss9644L_chr/Pss9644L_chr.gbff"
# "/mnt/shared/scratch/zzeng/genomes/ref/Pss9644L_chr.fasta"
# "/mnt/shared/scratch/zzeng/genomes/assembly_Pss9644Variants43ReSeq1PG2b1/241643_107x_min_500bp.fa"
BASE_PATH="/mnt/shared/scratch/zzeng/Snippy/PG2d_OWsubclade17_31mNG_Pss9097LongGB"
# "/mnt/shared/scratch/zzeng/Snippy/Pss9644Variants43ReSeq1Trim_refLongGB"

FILE_LIST="${BASE_PATH}/Strains.txt"
OUTPATH="${BASE_PATH}/OUT_DIR"
PREFIX="PG2d_OWsubclade17_31mNG_Pss9097LongGB"

### 1. Create txt file with all strains of interest ------------ ###
## Create a text file with all strain names ###
# mkdir -p $BASE_PATH
# mkdir -p $OUTPATH
# 
# ### Loop through each *_1.fastq.gz file in the input directory ###
# for file in "${INPATH}"/*_1_trim.fq.gz; do
#     basename=$(basename "$file" _1_trim.fq.gz)
#     echo "$basename" >> "$FILE_LIST"
# done
# test -d ${BB_WORKDIR} && /bin/rm -rf ${BB_WORKDIR}

### 2. Run snippy script -------------- ###
### Run Snippy on each strain (SNP calling) ###
# source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/snippy
# 
# cd "${BASE_PATH}" || { echo "Error: Could not change to BASE_PATH"; exit 1; }
# #### Loop through each strain in Strains.txt and run Snippy ###
# while read -r NAME; do
#     echo "Processing strain: $NAME"
# 
#     ### Check dependencies for each strain ###
#     echo "Checking dependencies with snippy-core check:"
#     snippy --version
# 
#     ### Run Snippy with the strain-specific names ###
#     snippy --outdir ${OUTPATH}/${NAME} \
#     --ref ${REF_GENOME} \
#     --R1 ${INPATH}/${NAME}*_1_trim.fq.gz \
#     --R2 ${INPATH}/${NAME}*_2_trim.fq.gz \
#     --mincov 10 \
#     --minfrac 0.9 \
#     --mapqual 60 \
#     --rgid ${NAME}
# 
# #### Check if Snippy succeeded ###
#     if [ $? -eq 0 ]; then
#         echo " Snippy completed successfully for ${NAME}"
#     else
#         echo " Error: Snippy failed for ${NAME}. Check logs or input files."
#         exit 1  # or: continue, depending on whether you want to stop everything
#     fi
#     
# done < Strains.txt
# test -d ${BB_WORKDIR} && /bin/rm -rf ${BB_WORKDIR}
### --mapqual is the minimum mapping quality to accept in variant calling. BWA MEM using 60 to mean a read is "uniquely mapped".

### 3. Run snippy core ----------------
### Combine all strains into one SNP core alignment (snippy-core) ###

# source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/snippy
# 
# cd "${BASE_PATH}" || { echo "Error: Could not change to BASE_PATH"; exit 1; }
# 
# ### Run snippy-core. ###
# snippy-core --ref "${REF_GENOME}" \
# --prefix "${PREFIX}" \
# $(find "${OUTPATH}" -mindepth 1 -maxdepth 1 -type d)
# 
# test -d ${BB_WORKDIR} && /bin/rm -rf ${BB_WORKDIR}

### 4. Use snippy to clean core alignment of "weird" letters i.e. X ---------------- ###
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/snippy

## Run snippy-clean ###
cd "${BASE_PATH}" || { echo "Error: Could not change to BASE_PATH"; exit 1; }
snippy-clean_full_aln "${PREFIX}.full.aln" > "${PREFIX}_clean.full.aln"
test -d ${BB_WORKDIR} && /bin/rm -rf ${BB_WORKDIR}

### Manually check core alignment.###
### 5. Create initial unmasked tree using IQTREE2 ------------------ ###
### Build initial unmasked tree with IQ-TREE2 to check topology and boostraps ###

