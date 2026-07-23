#!/bin/bash
#SBATCH --job-name=eggnog_array
#SBATCH --partition=medium
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=4-00:00:00
#SBATCH --array=8-16%2
#SBATCH --output=logs/eggnog_%A_%a.out
#SBATCH --error=logs/eggnog_%A_%a.err
#SBATCH --mail-user=m.molinag23@uniandes.edu.co
#SBATCH --mail-type=FAIL,END

# 1. Cargar el módulo
module unload eggnog bakta
module load eggnog/2.1.12

# 2. Configuración de IDs
ID=$(printf "%02d" $SLURM_ARRAY_TASK_ID)
SUFFIX="$ID"

# 3. Definir rutas
BAKTA_DIR="../bakta/bakta_results_${SUFFIX}"
OUTDIR="eggnog_results_${SUFFIX}"
mkdir -p logs "$OUTDIR"

echo "Buscando archivos .faa en: $BAKTA_DIR"

# Usamos find para capturar todos los .faa recursivamente
FILES_FOUND=$(find "$BAKTA_DIR" -name "*.faa")

if [ -z "$FILES_FOUND" ]; then
    echo "ERROR: No se encontraron archivos .faa en $BAKTA_DIR"
    ls -R "$BAKTA_DIR" # Esto imprimirá en el log qué hay realmente ahí
    exit 1
fi

for FAA_FILE in $FILES_FOUND; do
    BIN_NAME=$(basename "$FAA_FILE" .faa)
    
    echo "Analizando proteínas de: $BIN_NAME"

    emapper.py -i "$FAA_FILE" \
               --output "${BIN_NAME}" \
               --output_dir "$OUTDIR" \
               --data_dir /hpcfs/shared/bcem/databases/eggnog/v2 \
               -m diamond \
               --cpu $SLURM_CPUS_PER_TASK \
               --override
done