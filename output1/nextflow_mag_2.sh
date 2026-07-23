#!/bin/bash

#SBATCH --job-name=nfcore_mag
#SBATCH -p long
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --cpus-per-task=32
#SBATCH --mem=180G
#SBATCH --time=29-00:00:00
#SBATCH --mail-user=v.torres12@uniandes.edu.co
#SBATCH --mail-type=ALL
#SBATCH -o mag_job.o%j
#SBATCH -e mag_job.e%j

module load jdk/19.0.2
module load singularity/3.7.1
module load nextflow/25.04.8
hash -r

nextflow run nf-core/mag -r 5.4.1 \
  -resume \
  -profile singularity \
  -c mag.config \
  --input /hpcfs/home/cursos/bcom4102/grupos/Grupo_01/nuevoProyecto/secuenciasCrudas/samplesheet.csv \
  --outdir output \
  --clip_tool fastp \
  --save_clipped_reads \
  --host_fasta /hpcfs/home/cursos/bcom4102/grupos/Grupo_01/nuevoProyecto/bowtie/coffea.fna \
  --host_fasta_bowtie2index /hpcfs/home/cursos/bcom4102/grupos/Grupo_01/nuevoProyecto/bowtie/ \
  --host_removal_verysensitive \
  --save_hostremoved_reads \
  --keep_phix \
  --gtdb_db /hpcfs/home/cursos/bcom4102/grupos/Grupo_01/nuevoProyecto/secuenciasCrudas/gtdbtk_r226_data.tar.gz \
  --gtdbtk_pplacer_cpus 8 \
  --skip_metaeuk \
  --skip_spadeshybrid \
  --skip_ale \
  --bowtie2_mode="--very-sensitive" \
  --save_assembly_mapped_reads \
  --bin_domain_classification \
  --run_checkm2 \
  --checkm2_db /hpcfs/home/cursos/bcom4102/grupos/Grupo_01/nuevoProyecto/basejf/CheckM2_database/uniref100.KO.1.dmnd \
  --refine_bins_dastool \
  --postbinning_input both


