#!/bin/bash
#SBATCH --job-name=panaroo_run
#SBATCH --output=panaroo-%j.out
#SBATCH --error=panaroo-%j.err
#SBATCH --time=120:00:00
#SBATCH --mem-per-cpu=6750M
#SBATCH --ntasks=54
#SBATCH --nodes=1
#SBATCH --mail-type=ALL

module purge
module load bear-apps/2022a
module load panaroo/1.5.0-foss-2022a

# Run Panaroo
panaroo -i panaroo_input.txt -o panaroo_merged \
-t 50 \
--clean-mode strict \
-c 0.98 \
-f 0.7 \
--len_dif_percent 0.98 \
--aligner mafft \
--core_threshold 0.98 \
-a pan \
--merge_paralogs
