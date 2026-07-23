#!/bin/bash
#SBATCH --job-name=dbcan_cafe
#SBATCH --partition=medium
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=80G
#SBATCH --time=12:00:00
#SBATCH --array=0-5
#SBATCH --output=logs/dbcan_%A_%a.out
#SBATCH --error=logs/dbcan_%A_%a.err
#SBATCH --mail-user=m.molinag23@uniandes.edu.co
#SBATCH --mail-type=END,FAIL

# 1.  nuevo ambiente
source /hpcfs/home/cursos/bcom4102/miniforge3/etc/profile.d/conda.sh
conda activate dbcan
export PATH=$CONDA_PREFIX/bin:$PATH

SAMPLES=(SRR34971508 SRR34971509 SRR34971510 SRR34971511 SRR34971512 SRR34971514)

# Obtener el SRR (Array de Bash empieza en 0, por eso restamos 1)
INDEX=$SLURM_ARRAY_TASK_ID
SRR=${SAMPLES[$INDEX]}

# 3. Rutas (Ajustadas a tu estructura de salida)
BASE_DIR="../Annotation/Prodigal/MEGAHIT"
DB_DIR="db"
OUT_ROOT="dbcan_results_MEGAHIT"

# Ruta completa al archivo original
GZ_FILE="${BASE_DIR}/${SRR}/MEGAHIT-${SRR}_prodigal.faa.gz"
FAA_FILE="SPAdes-${SRR}_prodigal.faa"

mkdir -p $OUT_ROOT logs

echo "------------------------------------------------"
echo "Trabajando con la muestra: $SRR (Index: $INDEX)"
echo "Buscando en: $GZ_FILE"
echo "------------------------------------------------"

# 4. Verificación y Descompresión
if [ -f "$GZ_FILE" ]; then
    cp $GZ_FILE ./${FAA_FILE}.gz
    gunzip -f ./${FAA_FILE}.gz
else
    echo "ERROR: No se encontró el archivo $GZ_FILE"
    exit 1
fi
#DBCAN_EXEC=/hpcfs/home/cursos/bcom4102/miniforge3/envs/dbcan/bin/run_dbcan"
# 5. Ejecutar run_dbcan
# Importante: el comando 'protein' va DESPUÉS del archivo de entrada
run_dbcan CAZyme_annotation\
          --input_raw_data $FAA_FILE\
          --mode  protein \
          --output_dir ${OUT_ROOT}/${SRR} \
          --db_dir $DB_DIR \
          --threads 16
# 6. Limpieza
rm -f $FAA_FILE

echo "Finalizado con éxito para $SRR"
