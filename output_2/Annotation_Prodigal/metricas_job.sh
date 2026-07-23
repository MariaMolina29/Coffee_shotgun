#!/bin/bash
#SBATCH --job-name=prodigal_metrics    # Nombre del trabajo
#SBATCH --output=res_metrics_%j.log    # Archivo donde se guardará la salida (log)
#SBATCH --error=err_metrics_%j.err     # Archivo de errores
#SBATCH --nodes=1                      # Usar solo 1 nodo
#SBATCH --ntasks=1                     # 1 sola tarea
#SBATCH --cpus-per-task=2              # 2 CPUs son suficientes para zgrep
#SBATCH --mem=4G                       # 4GB de RAM es más que suficiente
#SBATCH --time=01:00:00                # Tiempo máximo (1 hora sobra)


# Imprimir el encabezado
echo "Ensamblador,Muestra,Num_Genes"> genes_conteo.csv

find . -name "*_prodigal.faa.gz" | while read archivo; do
    # Extraer el nombre base (ej: MEGAHIT-SRR34971508_prodigal.faa.gz)
    base=$(basename "$archivo")
    
    # Extraer el ensamblador (lo que está antes del primer guion)
    ensamblador=$(echo $base | cut -d'-' -f1)
    
    # Extraer la muestra (lo que está entre el primer guion y el guion bajo)
    muestra=$(echo $base | cut -d'-' -f2 | cut -d'_' -f1)
    
    # Contar genes
    conteo=$(zgrep -c "^>" "$archivo")
    
    # Guardar
    echo "$ensamblador,$muestra,$conteo" >> genes_conteo.csv
done
