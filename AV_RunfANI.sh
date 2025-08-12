#!/usr/bin/env bash
#SBATCH -p long
#SBATCH -J RunfANI      # Job name
#SBATCH --mem=50G           # Memory
#SBATCH -c 20               # 1 CPU cores

# Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/AV_RunfANI.sh

# Fastani will make pairwise comparisons of genome homology. We will use it to filter out whatever is too similar to continue filtering out some
# more genomes.

Folder="/mnt/shared/scratch/zzeng/fANI/AllSeq1797R39"
AllGenomes="/mnt/shared/scratch/zzeng/genomes/assembly_AllSeq1797R39"

### --- Step 1: Make list of paths of all assemblies --- ###
# mkdir -p ${Folder}
# cd ${Folder}
# find ${AllGenomes} -name "*.fna" > genome_list.txt
# find ${AllGenomes} -type f > genome_list.txt #Include all the files, no matter the file type
# ### Check the number of genomes ### 
# wc -l ${Folder}/genome_list.txt

### --- Step 2: Split the Genome List into Smaller Groups (partitions) --- ###
### Run Split file script. S1=genome list text file, S2=Number of partitions, S3=output dir ###
# sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/AV_SplitFiles.sh genome_list.txt 6 partitions/

### -- Step 3: Run fANI --- ###
### Run FastANI on each partition using genome_list.txt as query list, partition as reference and then the output file
cd ${Folder}
mkdir -p ${Folder}/out
for partition in ${Folder}/partitions/*; do
    par_file=$(basename "$partition")
    echo "Processing: $par_file"
    Jobs=$(squeue | grep -w 'fANI' | wc -l)
    while [ "$Jobs" -gt 20 ]; do
        sleep 10
        printf "."
        Jobs=$(squeue | grep -w 'fANI' | wc -l)
    done
    #fastANI --ql "$1" --rl "$2" -o "$3"
    sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/AV_fANI.sh ${Folder}/genome_list.txt "$partition" "out/$par_file"
done
