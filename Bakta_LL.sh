#!/usr/bin/env bash
#SBATCH -J Bakta
#SBATCH -p long
#SBATCH --mem=50G
#SBATCH --nodes=1 ###Does the job need to be run across nodes?
#SBATCH --ntasks=1 ###Number of tasks running simultaneously
#SBATCH -c 50  ###Number of cpus needed for each task

### Check before run:
### Need to update bakta --threads in the function

### Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/Bakta_LL.sh

### Create a temporary working directory on the scratch space. ###
### It seems temporary folders are not used in the following script, but they are actually used! ###
### Whenever a tool (like Bakta) internally writes temp files — which it does! — it will default to using $TMPDIR. ###
BB_WORKDIR=$(mktemp -d /mnt/shared/scratch/zzeng/${USER}_${SLURM_JOBID}.XXXXXX)
export TMPDIR=${BB_WORKDIR} #Set TMPDIR as the default for tools

### Set NXF_HOME to a directory with more space ###
export NXF_HOME="/mnt/shared/scratch/zzeng/bakta"

### Ensure the script stops on any error. Exit if theres an error ###
set -e 
### print every command before it’s executed ###
# set -x 

### activate bakta environment ###
source /mnt/apps/users/zzeng/conda/bin/activate /mnt/apps/users/zzeng/conda/envs/bakta

### Set variables for the paths ###
Genome_DIR="/mnt/shared/scratch/zzeng/genomes/assembly_AllSeq1797R39"
OUTPUT_BASE="/mnt/shared/scratch/zzeng/bakta/LightDB_AllSeq1797R39_compliant"
DB_PATH="/mnt/shared/scratch/zzeng/bakta/bakta_db_light/db-light"
# "/mnt/shared/scratch/zzeng/bakta/bakta_db/db"

### Create output directory if it doesn't exist ###
mkdir -p $OUTPUT_BASE

### Function to annotate genomes in a given directory ###
annotate_genomes() {
    local input_dir=$1
    local output_dir=$2

    echo "Annotating genomes in ${input_dir}..."
    mkdir -p $output_dir

	for genome in "${input_dir}"/*.fa "${input_dir}"/*.fna "${input_dir}"/*.fasta; do
    	[[ -f "$genome" ]] || continue  # Skip if glob didnt match anything

    	genome_name=$(basename "$genome")
    	genome_name="${genome_name%%.*}"  # Removes .fa, .fna, .fasta, etc.

        # Run Bakta
        echo "Annotating $genome_name..."
        bakta --threads $SLURM_CPUS_PER_TASK \
        	  --verbose --compliant --skip-crispr \
        	  --genus Pseudomonas \
              --db "$DB_PATH" \
              --output "${output_dir}/${genome_name}" \
              "$genome" \
              --skip-sorf \
              --prefix ${genome_name}
    done

    echo "Finished annotating genomes in ${input_dir}."
}

# Annotate genomes in Folder1
annotate_genomes "$Genome_DIR" "${OUTPUT_BASE}"

echo "All annotations completed!"

test -d ${BB_WORKDIR} && /bin/rm -rf ${BB_WORKDIR}
 
### Checks if the directory exists and is a directory (not a file). This prevents errors if the path doesnt exist.###
### && "If the previous command succeeded" — i.e., the directory does exist ###
### Recursively deletes the entire temporary folder and all contents without prompting ###