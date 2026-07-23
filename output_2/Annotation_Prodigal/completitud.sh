#!/bin/bash
#SBATCH --job-name=prodigal_metrics    # Nombre del trabajo
#SBATCH --output=res_metrics_%j.log    # Archivo donde se guardará la salida (log)
#SBATCH --error=err_metrics_%j.err     # Archivo de errores
#SBATCH --nodes=1                      # Usar solo 1 nodo
#SBATCH --ntasks=1                     # 1 sola tarea
#SBATCH --cpus-per-task=2              # 2 CPUs son suficientes para zgrep
#SBATCH --mem=4G                       # 4GB de RAM es más que suficiente
#SBATCH --time=01:00:00                # Tiempo máximo (1 hora sobra)

echo "Ensamblador,Muestra,Total,Completos" > completitud_total.csv
find . -name "*_prodigal.faa.gz" | while read f; do
    base=$(basename "$f")
    ensamblador=$(echo $base | cut -d'-' -f1)
    muestra=$(echo $base | cut -d'-' -f2 | cut -d'_' -f1)
    
    total=$(zgrep -c "^>" "$f") # Contar encabezados de genes
    completos=$(zgrep -c "partial=00" "$f")
    
    echo "$ensamblador,$muestra,$total,$completos" >> completitud_total.csv
done
