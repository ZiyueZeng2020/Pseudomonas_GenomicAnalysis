#!/usr/bin/env bash
#SBATCH -J LBakta
#SBATCH -p long
#SBATCH --mem=5G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously

# Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Bakta_Launch.sh

# Reminders:
# Check genome file types, .fa and .fna only?
# Check databse in Bakta_Sub.sh
# Check memory in Bakta_Sub.sh

# Trouble shooting:
# Try re-running one genome, failure can be caused by running too many genomes at the same time....
# Genmes need to be wrapped properly. Check headings of fasta file
# No "-" is allowed in fasta for bakta

set -e
set -x

# Folder with genome files
input_dir="/mnt/shared/scratch/zzeng/bakta/genomes_HorGCA"
output_dir_base="/mnt/shared/scratch/zzeng/bakta/LightDB_HorGCA"
# "/mnt/shared/scratch/zzeng/bakta/bakta_db/db"

for genome in "$input_dir"/*.fa "$input_dir"/*.fna; do
    [[ -f "$genome" ]] || continue

    genome_name=$(basename "$genome")
    genome_name="${genome_name%%.*}"  # Strip extension
    output_dir="${output_dir_base}/${genome_name}"

    # Wait if too many jobs are running
    while [ "$(squeue -u zzeng -n subBakta --noheader | wc -l)" -ge 20 ]; do
        echo "Waiting for job slots..."
        sleep 10
    done

    echo "Submitting: $genome_name"
###Variables: GENOME="$1", OUTDIR="$2", PREFIX="$3"
    sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Bakta_Sub.sh "$genome" "$output_dir" "$genome_name"
done
