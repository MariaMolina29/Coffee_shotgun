#!/bin/bash
#SBATCH --job-name=gtdb_serial
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --time=24:00:00
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=m.molinag23@uniandes.edu.co
#SBATCH --array=8-16%2

# 1. Cargar el ambiente/módulo
module load gtdbtk/2.1.1

# 2. Configuración de IDs
ID=$(printf "%02d" $SLURM_ARRAY_TASK_ID)
SUFFIX="$ID"

# 3. Definir carpetas
IN_DIR="/hpcfs/home/cursos/bcom4102/grupos/Grupo_01/nuevoProyecto/output/MAG_intento/MAGs_Filtrados_${SUFFIX}"
OUT_DIR="gtdbtk_results_${SUFFIX}"

echo "Procesando muestra $SUFFIX de forma serial para optimizar recursos."

# 4. Verificación de seguridad
if [ ! -d "$IN_DIR" ] || [ -z "$(ls -A $IN_DIR)" ]; then
    echo "Error: $IN_DIR no está listo. Saltando..."
    exit 1
fi

# 5. Ejecutar GTDB-Tk
gtdbtk classify_wf \
    --genome_dir $IN_DIR \
    --out_dir $OUT_DIR \
    --extension fa.gz \
    --cpus 16 \
    --pplacer_cpus 4

echo "Proceso terminado para $SUFFIX."
