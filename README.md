# Coffee_microbiome
Metagenomic shotgun sequencing analysis focused on the taxonomic and functional characterization of microbial communities involved in mucilage degradation using nf-core/mag pipeline.
Raw data from BioProject: PRJNA1305218

1. Pre-processing and filtering
2. Assembly with SPAdes and MEGAHIT
3. Prediction of protein-coding genes with Prodigal (contigs) and Prokka (bins)
4. Metagenome binning with 6 different binners
5. Checks quality with BUSCO and CheckM
6. Refines bins with DasTools
7. Assigns taxonomy with GTDB-tk and Tiara

Python scripts to make graphs
