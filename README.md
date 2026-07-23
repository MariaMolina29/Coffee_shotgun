# Coffee_microbiome
Metagenomic shotgun sequencing analysis focused on the taxonomic and functional characterization of microbial communities involved in mucilage degradation using (inicially) nf-core/mag pipeline.
Raw data from BioProject: PRJNA1305218

1. Pre-processing and filtering
2. Assembly with SPAdes and MEGAHIT
3. Prediction of protein-coding genes with Prodigal (contigs)

  From here, output1 shows the scripts used to do: 
5. Metagenome binning
6. Checks quality to create MAGs
7. Assigns taxonomy with GTDB-tk
8. Analysis with eggnog for GO
9. Protein prediction with bakta

  Now, output2 returns to part 3 and uses reads and contigs to:
10. Assigns taxonomy with Tiara and Kraken
11. Find mucilage degradation enzymes with dbCAN3

Python scripts for graphs
