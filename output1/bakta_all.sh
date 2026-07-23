#!/bin/bash
#SBATCH --job-name=bakta_coffee
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=24:00:00
#SBATCH --array=8-16%3
#SBATCH --output=logs/bakta_%A_%a.out
#SBATCH --error=logs/bakta_%A_%a.err
#SBATCH --mail-user=m.molinag23@uniandes.edu.co
#SBATCH --mail-type=END,FAIL

# 1. Cargar el ambiente
source activate /hpcfs/home/cursos/bcom4102/.conda/envs/bakta-env

# 2. Configuración de IDs
ID=$(printf "%02d" $SLURM_ARRAY_TASK_ID)
SUFFIX="$ID"

# 3. Definir rutas
# Entramos a la carpeta de MAGs filtrados de esta muestra específica
IN_DIR="../MAG_intento/MAGs_Filtrados_${SUFFIX}"
OUT_BASE="bakta_results_${SUFFIX}"
mkdir -p logs "$OUT_BASE"

echo "Iniciando anotación funcional para la muestra $SUFFIX"

# 4. Bucle interno: Bakta debe correr por cada archivo .fa.gz dentro de la carpeta
for FILENAME in "$IN_DIR"/*.fa.gz; do
    [ -e "$FILENAME" ] || continue # Por si la carpeta está vacía
    
    SAMPLE=$(basename "$FILENAME" .fa.gz)
    OUTDIR="${OUT_BASE}/${SAMPLE}"
    
    # Locus tag único combinando muestra y nombre del BIN para evitar colisiones
    # Ejemplo: B8_Bin1
    LOCUS="B${SUFFIX}_${SAMPLE#*SRR349715}" 

    echo "Anotando MAG: $SAMPLE..."

    # 5. Ejecutar Bakta
    bakta --db /hpcfs/shared/bcem/databases/bakta/v5.1/db-light \
          --output "$OUTDIR" \
          --prefix "${SAMPLE}" \
          --locus-tag "$LOCUS" \
          --threads $SLURM_CPUS_PER_TASK \
          --meta \
          --force \
          "$FILENAME"
done

echo "Anotación de la muestra $SUFFIX completada."
