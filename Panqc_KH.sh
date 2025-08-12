#!/bin/bash
#SBATCH --time 4:00:00
#SBATCH --ntasks 12

set -e

### Load BlueBEAR Environment ###
module purge; module load bluebear
module load bear-apps/2021b
module load Python/3.9.6-GCCcore-11.2.0

### Set up Virtual Environment ###
export VENV_DIR="${HOME}/virtual-environments"
export VENV_PATH="${VENV_DIR}/panqc-env-${BB_CPU}"

mkdir -p "${VENV_DIR}"

# Create venv if it doesn’t exist
if [[ ! -d "${VENV_PATH}" ]]; then
    python3 -m venv --system-site-packages "${VENV_PATH}"
fi

# Activate virtual environment
source "${VENV_PATH}/bin/activate"

# Use scratch for pip cache
export PIP_CACHE_DIR="/scratch/${USER}/pip"

### Install panqc from GitHub if not installed ###
if [[ ! -d "${VENV_PATH}/panqc" ]]; then
    cd "${VENV_PATH}"
    git clone https://github.com/maxgmarin/panqc.git
    cd panqc
    pip install .
    cd ..
fi

### Run panqc ###
cd "${VENV_PATH}/panqc"

# Replace the following with your actual paths:
FASTA_DIR="/rds/homes/k/kgh742/psf_wgs_project/01.RawData/02.TrimmedReads/04.SpadesOutputFiles/bakta_output/pangenome_gff_input"
STRAIN_PATHS="/rds/homes/k/kgh742/psf_wgs_project/01.RawData/02.TrimmedReads/04.SpadesOutputFiles/bakta_output/panaroo_reduced_merged-0106/InputAsmPaths.tsv"

REF_FASTA="/rds/homes/k/kgh742/psf_wgs_project/01.RawData/02.TrimmedReads/04.SpadesOutputFiles/bakta_output/panaroo_reduced_merged-0106/pan_genome_reference.fa"
GPA_CSV="/rds/homes/k/kgh742/psf_wgs_project/01.RawData/02.TrimmedReads/04.SpadesOutputFiles/bakta_output/panaroo_reduced_merged-0106/gene_presence_absence.csv"
OUTDIR="/rds/homes/k/kgh742/psf_wgs_project/01.RawData/02.TrimmedReads/04.SpadesOutputFiles/bakta_output/panaroo_reduced_merged-0106/NRC_results"

mkdir -p $OUTDIR 

# make input_tsv file from the gene presence absence to ensure correct strains listed

# Write header
echo -e "SampleID\tGenome_ASM_PATH" > "$STRAIN_PATHS"

# Extract strain names from header (skip first 3 columns)
cut -d',' -f4- "$GPA_CSV" | head -n1 | tr ',' '\n' | while read -r strain; do
    echo -e "${strain}\t${FASTA_DIR}/${strain}.fna" >> "$STRAIN_PATHS"
done

echo "Generated $STRAIN_PATHS"

# Run PanQC --->

panqc nrc \
  -a $STRAIN_PATHS \
  -r $REF_FASTA \
  -m $GPA_CSV \
  -o $OUTDIR/
