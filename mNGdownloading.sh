#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J mNGdowload
#SBATCH --mem=50G
#SBATCH --cpus-per-task=8

#Real path of this script: /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/mNGdownloading.sh

DownloadLinks=(
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/0b9371c6b9_20221107_Zeng1/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/4b7bc4374e_20221107_Zeng2/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/d216acea20_20221107_Zeng3/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/391949b9b2_20221107_Zeng4/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/f09bacf2c5_20221107_Zeng5/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/bc54b39dd0_20221107_Zeng6/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/2bd43307cf_20221107_Zeng7/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/23f09a29fe_20221107_Zeng8/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/9e2bae4e2d_20221107_Zeng9/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/4729d575c6_20221107_Zeng10/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/942b7e86ae_20230217_Zeng1/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/c4359673fe_20230217_Zeng2/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/9984c46be3_20230217_Zeng3/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/df1c7a87b8_20230217_Zeng4/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/fdb01c72e1_20230217_Zeng5/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/03a5f4b1a7_20230217_Zeng6/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/328453c2b7_20230217_Zeng7/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/b147edf203_20230217_Zeng8/untrimmed_urls.txt"
  # "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/848aa7149e_20230217_Zeng10/untrimmed_urls.txt"
  )
 
downloadDir=/mnt/shared/scratch/zzeng/pseudomonasProject/SeqStrains
subDir=${downloadDir}/XXXX

# mkdir -p ${downloadDir}

  for x in ${DownloadLinks[@]}; do
      cd ${downloadDir}
      wget -r ${x}
    cd ${downloadDir}/microbesng*/*/*
    for x in $(cat untrimmed_urls.txt); do
        wget ${x}
    done 
    i=$(ls | grep -v "untrimmed_urls.txt" | cut -c 1-6)
    for y in ${i}; do 
        mkdir ${y}
        mv ${y}_* ${y}
        mv ${y} ${downloadDir}
    done 
    rm -r ${downloadDir}/microbesng*
  done 

cd ${downloadDir} 
mkdir ${subDir} 
mv * ${subDir}

###(cat untrimmed_urls.txt| head OR tail -n 5) (First 5 reads!!2 reads for each strain, so the first 5 includes sequenes only for 3 strains. In the folder, there are 2 reads for the first and the second  strain, but only one read for the third strain.)
###date | awk '{print $1"_"$2"_"$3"_"$6"_"$4}'| sed 's/:/_/g'
###[@] is used to reference all elements of an array. When used within a loop or in a context that requires accessing individual elements of an array, [@] ensures that each element is treated separately
###The -r option in wget stands for recursive download, allowing you to download files recursively from a given URL.

