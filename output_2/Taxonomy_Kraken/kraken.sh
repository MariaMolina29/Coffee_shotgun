#!/bin/bash
#SBATCH --job-name=kraken_co
#SBATCH --partition=medium
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=120G
#SBATCH --time=05:00:00
#SBATCH --array=8-12,14%2
#SBATCH --output=logs/kraken_%A_%a.out
#SBATCH --error=logs/kraken_%A_%a.err
#SBATCH --mail-user=m.molinag23@uniandes.edu.co
#SBATCH --mail-type=END,FAIL

# 1. Cargar módulos
module load kraken/2

# 2. Configuración de rutas y archivos

IN_ROOT="../reads"
OUT_DIR="results_reads"
mkdir -p $OUT_DIR logs

# Definir la base de datos

DB_PATH="/hpcfs/shared/bcem/databases/kraken2/Standard/20241228/"
ID="SRR349715$(printf "%02d" $SLURM_ARRAY_TASK_ID)"
READ1="${IN_ROOT}/${ID}/${ID}_run0_fastp_1.fastp.fastq.gz"
READ2="${IN_ROOT}/${ID}/${ID}_run0_fastp_2.fastp.fastq.gz"

#ID=$(printf "%02d" $SLURM_ARRAY_TASK_ID)
#GZ_FILE="${IN_DIR}/SRR349715${ID}/SRR349715${ID}.contigs.fa.gz"

# 4. Ejecución de Kraken2 para Paired-End Reads
if [ -f "$READ1" ] && [ -f "$READ2" ]; then
    kraken2 --db $DB_PATH \
            --threads $SLURM_CPUS_PER_TASK \
            --paired \
            --output ${OUT_DIR}/${ID}.kraken \
            --report ${OUT_DIR}/${ID}.report \
            --use-names \
            --gzip \
            $READ1 $READ2
else
    echo "ERROR: No se encontraron las lecturas para $ID en $IN_ROOT"
    exit 1
fi

echo "Finalizado: $ID"
