"blastEffectors(){
	effectors=/mnt/shared/projects/niab/pseudomonas/michelle_effectors/Pss/attempt1/t3es.fasta
	db=/home/jconnell/pseudomonas/roary_pangenome/T3SS_T3ES_db
	makeblastdb -in ${1} -parse_seqids -blastdb_version 5 -out $db/${2}_db/${2} -dbtype nucl 
	tblastn -query ${effectors} -db $db/${2}_db/${2} -out ${3}/${2}_hits_table -evalue 1e-5 -outfmt 6 -num_threads $(nproc)
}"
