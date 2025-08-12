#!/usr/bin/env bash
#SBATCH -J SpeciesID
#SBATCH -p short 
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1
 
 
####Specied identificaiton for MNG sequenced pseudomonas strains 
####Three methods, ANI, BLAST, MNG SI results
 
###💻Real path of this script: sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/SpeciesIdentification.sh
##############################
######## Define paths ########
##############################
outDirMain=/mnt/shared/scratch/zzeng/pseudomonasProject/BlastGenome/Test
strains=/mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/Test
#/mnt/shared/scratch/zzeng/pseudomonasProject/SeqStrains/Test_2strains
#/mnt/shared/scratch/zzeng/pseudomonas_genomes/mNG/SamplingPs_QC540
mng_TD=/mnt/shared/projects/niab/pseudomonas/MNG_TD

mkdir -p ${outDirMain}

##############################
######## Trim reads ##########
##############################
trimReads(){
for x in $(ls ${strains}); do
    TrimOutDir=${strains}/${x}/trimmedReads_trimGalore
	ForwardReads=${strains}/${x}/*_1.fastq.gz
	ReverseReads=${strains}/${x}/*_2.fastq.gz
	mkdir -p ${TrimOutDir}/F
	mkdir -p ${TrimOutDir}/R
	
	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]]; do 
		sleep 60s
	done 
	sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/trimGenome.sh ${TrimOutDir} ${ForwardReads} ${ReverseReads}
	
done
}

#🌷🌷🌷
#trimReads


##############################
########  Assembly  ##########
##############################
###Trimmed reads are stored in the following folders.Spades does not do trimming. Original JC script F and R reads need to be updated
assembleReads(){
for x in $(ls ${strains}); do
	forward=$(ls ${strains}/${x}/trimmedReads_trimGalore/*1.fq.gz)
	reverse=$(ls ${strains}/${x}/trimmedReads_trimGalore/*2.fq.gz)
	AssemblyOutDir=${strains}/${x}/assembly
	mkdir -p ${AssemblyOutDir}
	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]]; do 
		sleep 60s
	done 
	sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/genomeAssembly.sh ${forward} ${reverse} ${AssemblyOutDir} correct ${x}
done 
}

#🌷🌷🌷
#assembleReads

########################
######## fANI ##########
########################
FastANI(){
for x in $(ls ${strains}); do
	assembly=$(ls ${strains}/${x}/assembly/filtered_contigs/*.fasta) 
	fANIoutDir=${strains}/${x}/ANI
	mkdir -p ${fANIoutDir}
	while [[ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]]; do
		sleep 60 
	done
	sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/fANI.sh ${assembly} ${fANIoutDir}/${x}.txt
done 
}
#🌷🌷🌷
#FastANI

##############################
######## fANI table ##########
##############################

fANI_result_table(){
for x in $(ls ${strains}); do
	bestHit=$(cat ${strains}/${x}/ANI/* | sed -n 1p)
	echo ${bestHit} >> ${outDirMain}/bestANIHits_AllColumns.txt
done 

while read x; do 
			path1=$(echo ${x} | cut -d " " -f1 | rev | cut -d "/" -f1 | rev)
			path2=$(echo ${x} | cut -d " " -f2 | rev | cut -d "/" -f1 | rev)
			path3=$(echo ${x} | cut -d " " -f3)
			echo -e "${path1}\t${path2}\t${path3}" >> ${outDirMain}/bestANIHits_OnlyColumns.txt
done <<< $(cat ${outDirMain}/bestANIHits_AllColumns.txt) 

sed -i '/^$/d' ${outDirMain}/bestANIHits_OnlyColumns.txt
}

#🌷🌷🌷
#fANI_result_table

################################
######## Blast genome ##########
################################

####Create blast lists 
blast(){
# source activate /mnt/shared/scratch/zzeng/apps/conda/envs/samtools
# for x in $(ls ${strains}); do
# 	assembly=$(ls ${strains}/*.fa)
#   	#assembly=$(ls ${strains}/${x}/assembly/filtered_contigs/*.fasta)
#   	mkdir -p ${outDirMain}/blastLists  
#     #samtools faidx ${assembly} contig_1 > ${outDirMain}/blastLists/${x}.txt
# 	samtools faidx ${assembly} $(sed -n 1p ${assembly}| sed 's/>//g') > ${outDirMain}/blastLists/${x}.txt
# done
# conda deactivate
#samtools faidx is to eaxtract node1 for each genome. Both "samtools faidx" lines work, node 1 will be pulled out.

for x in $(ls ${outDirMain}/blastLists/*.fa.txt); do
	name=$(basename ${x})
	blastDir=${outDirMain}/blastResults_JC
	mkdir -p ${blastDir}
	blastdb=/mnt/shared/projects/niab/pseudomonas/blast/prokaryote/ref_prok_rep_genomes
  		while [ $(squeue -u ${USER} --noheader | wc -l) -gt 100 ]; do
    		sleep 60s
  		done
  	sbatch /mnt/shared/home/zzeng/git_hub/scripts/pseudomonasAnalysis/blastGenome.sh ${x} ${blastdb} ${blastDir}/${name}
done
}
###Results(column names): query acc.ver, subject acc.ver, % identity, alignment length, mismatches, gap opens, q. start, q. end, s. start, s. end, evalue, bit score

#🌷🌷🌷
blast
###shot-1G-1cpu for 2 strains -> OK

###############################
######## Blast table ##########
###############################

#####Add new col with hit length

####Create a concatenated list 
concatBlast(){
for x in $(ls ${outDirMain}/blastResults_3/*); do
	echo $(basename ${x} .txt) $(cat ${x} | sed -n 1p| cut -d$'\t' -f2-4) $(cat ${x} | sed -n 1p| rev | cut -d$'\t' -f1 | rev) >> ${outDirMain}/blastHits.txt 
done  
}
###If there's more than 1 hit, sort blast results based on bit score in the 12th column: cat ${x}|awk '{print $0}' | sort -nrk12 >> ${x}

###Check whether column3(Blast%) has been added
#🌷🌷🌷
#concatBlast

#############################
######## mNG table ##########
#############################

sort_MNG_SI(){
	cat ${1} | cut -d$'\t' -f1,12,13 | tail -n +2 >> ${2}
}

#cat ${1} | cut -d$'\t' -f1,12,13 | sed -e 's/["]//g' -e 's/,/ /g'| tail -n +2 >> ${2}
### s/["]//g: Removes all double quote characters (")
### tail -n +2: This command skips the first line of the processed file, which is often the header row in CSV files.

Table_MNG_SI(){
mng_TD=/mnt/shared/scratch/zzeng/pseudomonasProject/SeqStrains/mng_TD
for x in $(ls ${mng_TD}/*); do 
 	concatenatedMNG=${outDirMain}/concatenatedMNG.txt
 	sort_MNG_SI	${x} ${concatenatedMNG}
done
}
#🌷🌷🌷
#Table_MNG_SI
 
#####################################
######## Combined SI table ##########
#####################################
####Concat all data with bash python function
CombinedTable_blast_ANI(){
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

#🌷🌷🌷
#CombinedTable_blast_ANI ${outDirMain}/blastHits.txt ${outDirMain}/bestANIHits_OnlyColumns.txt ${outDirMain}/combinedData.txt


###Add headings to combined table
AddHeading_SItable(){
touch ${outDirMain}/final_ID.txt
echo -e "mNGStrain\tBlastSpecies\tBlastIdentity\tBlastLength\tBlastBitScore\tANI_StrainHit\tANI_Identity" > ${outDirMain}/final_ID.txt
cat ${outDirMain}/combinedData.txt | awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7}' >> ${outDirMain}/final_ID.txt
}

#🌷🌷🌷
#AddHeading_SItable

###Filtering for Ps strain list 
###cat ${outDirMain}/final_ID.txt | awk '($2 == "Pseudomonas_syringae")&&($5 > 94)&&($6 == "Pseudomonas_syringae"){print $0}' > ${outDirMain}/sortedPSstrains.txt

#Edit ref Ps strain names
EditName_SItable(){ 
# cp ${outDirMain}/final_ID.txt ${outDirMain}/tmp
# head -n 1 ${outDirMain}/tmp > ${outDirMain}/tmp_header
# tail -n +2 ${outDirMain}/tmp > ${outDirMain}/tmp_content

cat ${outDirMain}/tmp_content | awk '{split($6,a,"_");{print a[1]"_"a[2]"\t"$6}}' | while read x ; do
	echo ${x}
	oldName=$(echo ${x} | cut -d " " -f2)
	newName=$(cat /home/zzeng/scratch/pseudomonas_genomes/strainName/GenbankPs/GenBankPs_cerasi_PG25 | grep $(echo ${x} | cut -d " " -f1) | cut -d $'\t' -f2)
	echo  ${oldName} 
	# sed -i "s/${oldName}/${newName}/g" ${outDirMain}/tmp_content
done
 
# for x in $(cat ${outDirMain}/tmp_content | cut -f1); do 
# 	#echo ${x}
# 	oldname=${x}
# 	newName=$(cat /mnt/shared/projects/niab/pseudomonas/MNG_TD/MicrobesNG_20221107_Zeng1.csv | grep -o "${x}[_].*")
# 	sed -i "s/${oldname}/${newName}/g" ${outDirMain}/tmp_content
# done
# {
# 	cat tmp_header
# 	cat tmp_content
# } > ${outDirMain}/ReNamed_final_ID
}

#🌷🌷🌷
#EditName_SItable
