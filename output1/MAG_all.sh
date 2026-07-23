#!/bin/bash
#SBATCH --job-name=Filtrado_MAGs
#SBATCH --partition=short
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:20:00
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=m.molinag23@uniandes.edu.co
#SBATCH --array=8-16%4

# 1. Configuración de IDs
ID=$(printf "%02d" $SLURM_ARRAY_TASK_ID)
SUFFIX="$ID"

# 2. Definir rutas
REPORT="../GenomeBinning/MetaBAT2/report_${SUFFIX}_spades.tsv"
BINS_DIR="../GenomeBinning/MetaBAT2/bins"
OUT_DIR="MAGs_Filtrados_${SUFFIX}"
NUEVO_REPORTE="${OUT_DIR}/reporte_filtrado_${SUFFIX}.tsv"

# 3. Crear carpeta de salida
mkdir -p $OUT_DIR

echo "------------------------------------------------"
echo "Procesando Filtrado para Muestra: $SUFFIX"
echo "Criterio: Completitud > 50% y Contaminación < 10%"
echo "------------------------------------------------"

if [ -f "$REPORT" ]; then
    # --- NUEVO: Crear el nuevo reporte con el encabezado original ---
    head -n 1 "$REPORT" > "$NUEVO_REPORTE"

    # --- MODIFICADO: Guardar las líneas filtradas en el TSV y procesar archivos ---
    # Usamos awk para filtrar las líneas completas y las mandamos al nuevo TSV
    awk -F'\t' 'NR > 1 && $6 > 50 && $7 < 10' "$REPORT" >> "$NUEVO_REPORTE"

    # Ahora leemos el nuevo reporte para copiar los archivos .fa.gz
    # (Usamos NR > 1 para saltar el encabezado que acabamos de poner)
    awk -F'\t' 'NR > 1 { print $1 }' "$NUEVO_REPORTE" | while read BIN_ID; do
        if [ -f "$BINS_DIR/$BIN_ID.fa.gz" ]; then
            echo "Recuperando MAG de alta calidad: $BIN_ID"
            cp "$BINS_DIR/$BIN_ID.fa.gz" "$OUT_DIR/"
        else
            echo "Aviso: No se encontró $BIN_ID.fa.gz en $BINS_DIR"
        fi
    done
else
    echo "Error: No se encontró el reporte $REPORT"
    exit 1
fi

echo "------------------------------------------------"
echo "Proceso terminado para muestra $SUFFIX."
echo "Reporte filtrado guardado en: $NUEVO_REPORTE"
echo "Total de MAGs filtrados:"
ls "$OUT_DIR"/*.fa.gz 2>/dev/null | wc -l