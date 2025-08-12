# 1. Create txt file with all strains of interest ------------
# Create a text file with all strain names

for file in `ls *_1P.trim.fastq.gz`; do basename=$(basename $file _1P.trim.fastq.gz); echo ${basename} >> Strains.txt; done


# 2. Run snippy script --------------
# Run Snippy on each strain (SNP calling)

#!/bin/bash
#SBATCH --time 60:00
#SBATCH --ntasks 1

INPATH="/rds/homes/k/kgh742/psf_wgs_project/01.RawReads/02.TrimmedReads"
OUTPATH="/rds/homes/k/kgh742/psf_wgs_project/01.RawData/02.TrimmedReads/03.Snippy_L1928_masked"

set -e

module purge; module load bear-apps/2019b
module load snippy/4.6.0-foss-2019b-Perl-5.30.0
module load Python/3.7.4-GCCcore-8.3.0

# Loop through each strain in Strains.txt and run Snippy
while read -r NAME; do
    echo "Processing strain: $NAME"

    # Check dependencies for each strain
    echo "Checking dependencies with snippy-core check:"
    snippy --version

    # Run Snippy with the strain-specific names
    snippy --outdir $OUTPATH/${NAME} \
    --ref 246539E_W163A3B1_chrom.fasta \
    --R1 ${NAME}_1P.trim.fastq.gz \
    --R2 ${NAME}_2P.trim.fastq.gz \
    --mincov 10 \
    --minfrac 0.9 \
    --mapqual 60 \
    --rgid ${NAME}

done < Strains.txt
# --mapqual is the minimum mapping quality to accept in variant calling. BWA MEM using 60 to mean a read is "uniquely mapped".

# 3. Run snippy core ----------------
# Combine all strains into one SNP core alignment (snippy-core)

#!/bin/bash
#SBATCH --output=snippy-%j.out  
#SBATCH --error=snippy-%j.err  
#SBATCH --ntasks=16                     
#SBATCH --time=60:00

set -e

module purge; module load bear-apps/2019b
module load snippy/4.6.0-foss-2019b-Perl-5.30.0
module load Python/3.7.4-GCCcore-8.3.0

# Run snippy-core. 
snippy-core --prefix chrom_core_2022 --ref 246539E_W163A3B1_chrom.fasta NCPPB1006 C130a3b1 C250a4b2 C270a4b3 C400a1s2 C410a1s1 C420a1s2 C430a1s3 C450a3s3 C530a1b2 C560a1b2 C610a1b3 C630a3b1 C680a3b3 IoMN10D5R22 IoMN14D1R21 IoMN15D1R31 IoMN18D2R21 IoMN19D2R31 IoMN28D4R41 IoMN3D1R32 IoMN8D4R22 L1217a1b4 L1227a1b4 L1277a1b6 L1327a1b5 L1738a1b4 L1768a4b4 L1778a4b5 L1818a6b4 L1928a1b6 L1958a2b6 L2008a3b4 L2018a3b5 L777a5b1 L787a5b1 L797a5b1 L807a5b1 L817a5b2 L827a5b2 L837a5b2 L898a5b2 MardA1S4125 MatA1109 MatA2111 MatA2122 MatA2124 W10013a5b5 W1003a4b5 W1013a1b2 W1013a4b6 W1023a4b6 W10313a5b6 W1033a4b6 W1043a5b6 W1053a5b6 W1063a7b2 W1073a7b2 W1083a7b2 W1093a7b2 W1103a7b2 W1113a1b2 W1113a7b3 W1123a7b3 W113a1b1 W1143a7b3 W1153a9b3 W1163a11b1 W1173a11b1 W1213a1b2 W13013a12b2 W1313a1b2 W13a1b1 W1413a1b2 W1513a1b2 W1613a1b2 W1713a1b3 W183a3b2 W1913a1b3 W193a3b2 W2013a1b3 W203a3b2 W2113a1b3 W213a1b1 W2313a1b3 W2413a1b3 W273a3b5 W323a3b6 W343a4b1 W413a4b3 W423a4b3 W43a1b1 W573a5b1 W583a5b1 W593a5b1 W603a5b1 W613a1b1 W6913a4b2 W703a5b4 W7113a4b2 W7213a4b2 W723a5b4 W803a11b1 W813a1b1 W883a2b4 W8913a5b3 W893a3b4 W903a3b4 W9113a5b3 W913a1b2 W913a3b4 W9213a5b3 W923a3b4 W9313a5b4 W933a4b4 W943a4b4 W953a4b4 W9613a5b4 W973a4b5 W9813a5b5 W983a4b5 W9913a5b5 W993a4b5


# 4. Create initial unmasked tree using IQTREE2 ------------------
# Build initial unmasked tree with IQ-TREE2
#!/bin/bash
#SBATCH --time 120:00:00
#SBATCH --ntasks 32
#SBATCH --nodes 1

set -e

module purge
module load bear-apps/2022b
module load IQ-TREE/2.2.2.6-gompi-2022b

iqtree2 -s chrom_core_2022.aln \
-B 1000 -alrt 1000 -T 30 \
-pre chrom_core_2022_IQTREE_BS



# 5. Collapse clades <70 bootstrap support -------------

#!/bin/bash
set -e

module purge; module load bluebear

module load bear-apps/2022b
module load Miniforge3/24.1.2-0

eval "$(${EBROOTMINIFORGE3}/bin/conda shell.bash hook)"
source "${EBROOTMINIFORGE3}/etc/profile.d/mamba.sh"

# Define the path to your environment (modify as appropriate)
# N.B. this path will be created by the subsequent commands if it doesn't already exist
CONDA_ENV_PATH="/rds/homes/k/kgh742/psf_wgs_project/conda/${USER}_gotree"

export CONDA_PKGS_DIRS="/scratch/${USER}/conda_pkgs"

# Create the environment. Only required once.
mamba create --yes --prefix "${CONDA_ENV_PATH}"

# Activate the environment
mamba activate "${CONDA_ENV_PATH}"

# Choose your version of Python
mamba install --yes python=3.10

# Continue to install any further items as required. Only required once.
mamba install --yes gotree

# Activate the environment
mamba activate "${CONDA_ENV_PATH}"

gotree collapse support --support 70 --input chrom_core_2022_IQTREE_BS.treefile --output chrom_core_2022_IQTREE_70_BS.treefile


# For recombination analysis ----------------------

# 6. Use snippy to clean core alignment of "weird" letters i.e. X

#!/bin/bash
#SBATCH --output=snippy-%j.out  
#SBATCH --error=%j.err   
#SBATCH --ntasks=16                    
#SBATCH --time=60:00

module purge; module load bear-apps/2019b
module load snippy/4.6.0-foss-2019b-Perl-5.30.0
module load Python/3.7.4-GCCcore-8.3.0

# Run snippy-clean
snippy-clean_full_aln chrom_core_2022.full.aln > chrom_core_2022_clean.full.aln

# 7. Run Gubbins to extract recombinant regions --------------------

#!/bin/bash
#SBATCH --time 48:00:00
#SBATCH --ntasks 16
#SBATCH --nodes 1
#SBATCH --mail-type ALL

set -e

module purge; module load bear-apps/2022a
module load Gubbins/3.3.1-foss-2022a

run_gubbins.py chrom_core_2022_clean.full.aln