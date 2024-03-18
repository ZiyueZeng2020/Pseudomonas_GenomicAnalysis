#!/usr/bin/env bash
#SBATCH -p short
#SBATCH -J BlaGenome
#SBATCH --cpus-per-task=4
#SBATCH --mem=25G
#SBATCH --output=/dev/null


QUERY=$1
DATABASE=$2
BlastHit=$3

source activate blast

blastn \
-query ${QUERY} \
-db ${DATABASE} \
-out ${BlastHit} \
-outfmt 6 \
-max_target_seqs 1 \
-max_hsps 1 \
-num_threads $(nproc)

### Echo completion
echo "BLAST search completed. Results are in results.txt"

##Could define info to be included: -outfmt "6 stitle pident length evalue bitscore"
###Results(column names): query acc.ver, subject acc.ver, % identity, alignment length, mismatches, gap opens, q. start, q. end, s. start, s. end, evalue, bit score
###-max_target_seqs 1 limits the number of target sequences reported per query, while -max_hsps 1 limits the number of HSPs reported per alignment. They control different aspects of the BLAST output and can be used together if you want to see only the single best match (target sequence) and only the single best alignment (HSP) for each query.
