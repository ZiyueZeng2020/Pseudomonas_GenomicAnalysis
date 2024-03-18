####################################
####### Genome Downloading #########
####################################
DownloadLinks=(
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/0b9371c6b9_20221107_Zeng1/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/4b7bc4374e_20221107_Zeng2/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/d216acea20_20221107_Zeng3/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/391949b9b2_20221107_Zeng4/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/f09bacf2c5_20221107_Zeng5/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/bc54b39dd0_20221107_Zeng6/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/2bd43307cf_20221107_Zeng7/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/23f09a29fe_20221107_Zeng8/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/9e2bae4e2d_20221107_Zeng9/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/4729d575c6_20221107_Zeng10/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/942b7e86ae_20230217_Zeng1/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/c4359673fe_20230217_Zeng2/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/9984c46be3_20230217_Zeng3/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/df1c7a87b8_20230217_Zeng4/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/fdb01c72e1_20230217_Zeng5/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/03a5f4b1a7_20230217_Zeng6/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/328453c2b7_20230217_Zeng7/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/b147edf203_20230217_Zeng8/untrimmed_urls.txt"
  "https://microbesng-data.s3-eu-west-1.amazonaws.com/projects/848aa7149e_20230217_Zeng10/untrimmed_urls.txt"
  )
 
downloadDir=/home/jconnell/jconnell/pseudomonasSequencingData_zeng1_to_10_and_1234567p8p10_$(date | awk '{print $1"_"$2"_"$3"_"$6"_"$4}' | sed 's/:/_/g')
mkdir -p ${downloadDir}
 
for x in ${DownloadLinks[@]}; do
    cd ${downloadDir}
    wget -r ${x}
    cd microbesng*/*/*
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
mkdir 241185_248100 
mv * 241185_248100

###################################
######## Genome Assembly ##########
###################################

#!/usr/bin/env bash
#SBATCH -J SPAdes
#SBATCH --partition=medium
#SBATCH --mem=20G
#SBATCH --cpus-per-task=8
#SBATCH --output=/dev/null
 
########################################################################
#Input
# 1st argument: Forward read
# 2nd argument: Reverse read
# 3rd argument: Output directory 
# 4th argument: correction 
# 5th Cutoff
#Output
# Assembly
 
 
R1=$1
R2=$2
OutDir=$3
Correction=$4
strainName=$5
Cutoff='auto'
F_Read=$(basename $R1)
R_Read=$(basename $R2)
 
cp $R1 $R2 $TMPDIR
cd $TMPDIR
 
SpadesDir=/home/jconnell/miniconda3/pkgs/spades-3.13.0-0/share/spades-3.13.0-0/bin
$SpadesDir/spades.py -m 200 --phred-offset 33 --careful -1 $F_Read -2 $R_Read -t 30  -o $TMPDIR --cov-cutoff "$Cutoff"
 
mkdir -p $TMPDIR/filtered_contigs
FilterDir=/mnt/shared/scratch/jconnell/private/git_repos/niab_repos/pipeline_canker_cherry/cherry_canker_pipeline
$FilterDir/filter_abyss_contigs.py scaffolds.fasta 500 > filtered_contigs/${strainName}_min_500bp.fasta
 
rm $F_Read
rm $R_Read
cp -r * $OutDir

#Pangenome and gene absence/presence
####Include path tested strains from variant calling 
analysisTwo(){
source activate prokka 
for x in $(cat /mnt/shared/scratch/jconnell/pangenomeGVCFbatch/results/pathTestStrainList); do 
	analysisDir=/mnt/shared/scratch/jconnell/curatedPanaroo_664_strains/pathTestAnalysis
	genomeAssembly=/mnt/shared/projects/niab/pseudomonas/pseudomonasSequencingData_zeng1_to_10_and_1234567p8p10_Wed_18_Oct_2023_14_16_09/241185_248100/${x}/assembly/filtered_contigs/${x}_min_500bp.fasta
	name=$(basename ${genomeAssembly} .fasta)
	mkdir -p ${analysisDir}/genomes ${analysisDir}/prokka_annotations/${name} ${analysisDir}/results ${analysisDir}/pathTestResults
	cp ${genomeAssembly} ${analysisDir}/genomes
	prokka \
	--cpus $(nproc) \
	--kingdom Bacteria \
	--genus Pseudomonas \
	--strain ${name} \
	--proteins /home/jconnell/projects/niab/pseudomonas/prokka_protein_db/ps.gbk \
	--prefix ${name} \
	--outdir ${analysisDir}/prokka_annotations/${name} \
	--force \
	${genomeAssembly}
done 
conda deactivate
 
source activate panaroo 
for x in $(ls ${analysisDir}/prokka_annotations/*/*.gff); do 
	cp ${x} $TMPDIR
done 
cd $TMPDIR
panaroo -i *.gff -o results_unmerged --clean-mode strict --remove-invalid-genes
cp -r results_unmerged $analysisDir/pathTestResults
panaroo -i *.gff -o results_merged --clean-mode strict --remove-invalid-genes --merge_paralogs
cp -r results_merged $analysisDir/pathTestResults
}
 
analysisTwo

#SBATCH -J sID
#SBATCH -p long 
#SBATCH --mem=4G
#SBATCH --cpus-per-task=4
 
 
####Specied identificaiton for MNG sequenced pseudomonas strains 
####Three methods, ANI, BLAST, MNG SI results
 
####Define paths 
outDirMain=/mnt/shared/projects/niab/pseudomonas/MNG_SI
strains=/mnt/shared/projects/niab/pseudomonas/pseudomonasSequencingData_zeng1_to_10_and_1234567p8p10_Wed_18_Oct_2023_14_16_09/241185_248100
blastdb=/home/jconnell/niab/pseudomonas/blast/prokaryote/ref_prok_rep_genomes
samtoolsPath=/mnt/shared/scratch/jconnell/apps/miniconda3/bin/samtools
mng_TD=/mnt/shared/projects/niab/pseudomonas/MNG_TD
 
assembleReads(){
for x in $(ls ${strains}); do
	forward=$(ls ${strains}/${x}/*_1.fastq.gz)
	reverse=$(ls ${strains}/${x}/*_2.fastq.gz)
	outDir=${strains}/${x}/assembly
	mkdir -p ${outDir}
	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]]; do 
		sleep 60s
	done 
	sbatch /mnt/shared/home/jconnell/git_repos/niab_repos/pseudomonas_analysis/AutomatedGenomeAnalysis/I_O_modified_spades.sh ${forward} ${reverse} ${outDir} correct ${x}
done 
}
 
FastANI(){   
for x in $(ls ${strains}); do
	assembly=$(ls ${strains}/${x}/assembly/filtered_contigs/*.fasta) 
	outDir=${strains}/${x}/ANI
	mkdir -p ${outDir}
	k=12
	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]]; do
		sleep 60 
	done
	sbatch /mnt/shared/home/jconnell/git_repos/niab_repos/pseudomonas_analysis/ANI/submitfastANI.sh ${assembly} ${outDir}/${x}.txt ${k}
done 
}
 
ANI_result_table(){ 
for x in $(ls ${strains}); do
	bestHit=$(cat ${strains}/${x}/ANI/* | sed -n 1p | sed 's/\t//1' | awk '{split($1,a,"/");{print a[9],a[21],$2}}')
	echo ${bestHit} >> ${outDirMain}/bestANIHits.txt
done 
sed -i '/^$/d' ${outDirMain}/bestANIHits.txt
}
 
# ##################
# #                #
# #     Blast      #
# #                #
# ##################
 
####Add new col with hit length
 
####Create blast lists 
blast(){
for x in $(ls ${strains}); do
  	assembly=$(ls ${strains}/${x}/assembly/filtered_contigs/*.fasta)
  	mkdir -p ${outDirMain}/blastLists  
    samtools faidx ${assembly} $(cat ${assembly} | sed -n 1p | sed 's/>//g') > ${outDirMain}/blastLists/${x}.txt
done
 
for x in $(ls ${outDirMain}/blastLists/*); do
	name=$(basename ${x} .txt)
	mkdir -p ${outDirMain}/blastResults
	blastdb=/home/jconnell/niab/pseudomonas/blast/prokaryote/ref_prok_rep_genomes
	ProgDir=/home/jconnell/git_repos/niab_repos/pseudomonas_analysis/AutomatedGenomeAnalysis
  		while [ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]; do
    		sleep 60s
  		done
  	sbatch ${ProgDir}/blast.sh ${x} ${outDirMain}/blastResults ${blastdb}
done
}
 
####Create a concatenated list 
concatBlast(){
for x in $(ls ${outDirMain}/blastResults/*); do
	echo $(basename ${x} _result.txt) $(cat ${x} | cut -d " " -f1-2) $(cat ${x} | rev | cut -d$'\t' -f1,2,3,4  | rev) >> ${outDirMain}/blastHits.txt 
done  
}
 
 
sort_MNG_TD(){
	cat ${1} | cut -d "," -f1,12,13 | sed -e 's/["]//g' -e 's/,/ /g'| tail -n +2 >> ${2}
}
 
####Concat all data with bash python function #groovy 🤣
condatData(){
python <<concat
with open("$1", 'r') as fi, open("$2", 'r') as fii , open("$3", 'w') as out:
	blast = [x.strip().split() for x in fi.readlines()]
	ani = [x.strip().split() for x in fii.readlines()]
	combinedDict = {}
	for x in blast:
		combinedDict[x[0]] = []
		if x[0] in combinedDict:
			combinedDict[x[0]].append("\t".join(x[1:]))
	for x in ani:
		if x[0].split("_")[0] in combinedDict:
			combinedDict[x[0].split("_")[0]].append("\t".join(x[1:]))
	for x,y in combinedDict.items():
		j=" ".join(map(str,y))
		out.write(f"{x}\t{j}\n")
concat
}
 
####Run concat 
runConcat(){
# for x in $(ls ${mng_TD}/*); do 
#  	concatenatedMNG=${outDirMain}/concatenatedMNG.txt
#  	sort_MNG_TD	${x} ${concatenatedMNG}
# done 
condatData ${outDirMain}/blastHits.txt ${outDirMain}/bestANIHits.txt ${outDirMain}/combinedData.txt
}
 
 
####Sort the final list 
#echo -e "MNG Strain\tBlast Species\tBlast % ID\tMNG Species\t%ID\tANI Strain Hit\t% Identity" > ${outDir}/final_ID.txt
#cat ${outDir}/combinedData.txt | awk '{print $1"\t"$2"_"$3"\t"$4"\t"$7"_"$8"\t"$9"\t"$5"\t"$6}' >> ${outDir}/final_ID.txt
#cat ${outDir}/final_ID.txt | awk '($2 == "Pseudomonas_syringae")&&($5 > 94)&&($6 == "Pseudomonas_syringae"){print $0}' > ${outDir}/sortedPSstrains.txt
 
 
###edit names 
cat ${outDirMain}/tmp | grep "GCA" | awk '{split($6,a,"_");{print a[1]"_"a[2]"\t"$6}}' | while read x ; do
	oldName=$(echo $x | cut -d " " -f2)
	newName=$(cat /mnt/shared/projects/niab/pseudomonas/pyaniStrainsAmplicons/fullNames | grep $(echo $x | cut -d " " -f1) | cut -d $'\t' -f2)
	echo $oldName $newName
#	sed -i "s/\(\t${oldName}\t\)/\(\t${newName}\t\)/g" ${outDirMain}/tmp
	sed -i "s/${oldName}/${newName}/g" ${outDirMain}/tmp
done
 
# for x in $(cat ${outDir}/final_ID.txt | cut -f1); do 
# 	oldname=$x
# 	newName=$(cat /mnt/shared/home/jconnell/MNG_TD_cat | grep -o "$x[_].*")
# 	sed -i "s/${oldname}/${newName}/g" ${outDir}/final_ID.txt 
# done


#Original JC tutorial script:
# source activate blast
# outdir=/mnt/shared/scratch/zzeng/pseudomonasProject/Blast
# effectors=/mnt/shared/projects/niab/pseudomonas/michelle_effectors/Pss/attempt1/t3es.fasta
# genome=/mnt/shared/scratch/zzeng/pseudomonas_genomes/ref9_PG
# for x in $(ls ${genome}/*); do
# 	strain=$(basename ${x} .fna)
# 	echo ${strain}
# 	mkdir -p ${outdir}/database/${strain}
# 	mkdir -p ${outdir}/results
# 	makeblastdb -in ${x} -parse_seqids -blastdb_version 5 -out ${outdir}/database/${strain} -dbtype nucl 
# 	tblastn -query ${effectors} -db ${outdir}/database/${strain} -out ${outdir}/results/${strain}_hitable.txt -evalue 1e-5 -outfmt 6 -num_threads $(nproc)
# done