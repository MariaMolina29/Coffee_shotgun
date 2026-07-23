# Coffee_microbiome
Metagenomic shotgun sequencing analysis focused on the taxonomic and functional characterization of microbial communities involved in mucilage degradation using (inicially) nf-core/mag pipeline.
Raw data from BioProject: PRJNA1305218

1. Pre-processing and filtering
2. Assembly with SPAdes and MEGAHIT
3. Prediction of protein-coding genes with Prodigal (contigs)
   
  From here, output1 shows the scripts used to do: 
- Metagenome binning
- Checks quality to create MAGs
- Assigns taxonomy with GTDB-tk
- Analysis with eggnog for GO
- Protein prediction with bakta

  Now, output2 returns to part 3 and uses reads and contigs to:
- Assigns taxonomy with Tiara and Kraken
- Find mucilage degradation enzymes with dbCAN3

Python scripts for graphs
(The nf_core/mag pipeline was stopped at the binning process due to the lack of resources and the end of the course.)
