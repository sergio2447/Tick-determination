# Tick determination
A snakemake pipeline for tick determination from ONT whole genome sequencing samples (after basecalling).

## Introduction

## 🐍 Workflow

![Workflow](https://github.com/sergio2447/Tick-determination/blob/main/Blank%20diagram.png)

## Input and output

### Input data

The input data is oxford nanopore sequencing data after basecalling. The data format should be in fastq.gz. Every data sample that you want to go through the snakemake workflow should be in the input_data directory.

### Output directories
all these directorys can be found in the output_data directory.
1. nanoplot_raw_data: contains the nanoplot results of the raw samples. in the sumary report is the read quality shown.
2. nanoplot_filterd_data: contains the nanoplot results of the filterd samples. in the sumary report is the read quality shown.
3. filterd_data: Here is the filterd data stored after filtering.
4. minimap2_data: The mapped reads are here stored in sam format.
5. samtools_data: The sorted and transformed files to extract the mapped reads are stored here. also the consesus sequence in fastq format is stored in this directory.
6. consensus_and_kraken_data: The consensus sequence in fasta format and kraken output can be found in this directory.
7. results: From the samtools flagstats are 2 txt files per sample stored from before and after extracting reads to view how manny reads are mapped. Also the results from the kraken allignment against the reference sequences database are shown here in a txt file containing the classification of the species.

## instalations

### downloading the pipeline
for downloading the pipeline use:
```bash
wget https://github.com/sergio2447/Tick-determination/archive/refs/heads/main.zip > Tick_determination.zip
```
to download this repository from github and unzip the file with:  
```bash
unzip Tick_determination.zip
```

### Installing miniconda
Download miniconda3:
```bash
curl -O https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
```

After the file is downloaded use:
```bash
bash Miniconda3-py310_23.3.1-0-Linux-x86_64.sh
```
to install miniconda3. Keep in mind that python 3.10 is required to install this version of miniconda3.

At the end of the instalation there will be a request to download conda init. Please type **"yes"** here. This will add some code to your .bashrc file, which is important to work with correctly.

**Please close and reopen the terminal, to complete the installation.**

### updating and instaling conda changels
After closing and reopening the terminal you should be able tu update conda: `conda update --yes conda`.
When its done updating download the following chanels:

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

### creating a snake make environment
For creating the snakemake environment you should use this in the terminal: 
```bash
conda create -n snakemake -c bioconda snakemake python=3.10
```
After this environment is created use `conda activate snakemake` to activate the environment.

## configurating the pipeline to your needs.
For the configuration of the pipeline there are several parts which can be tweaked for your own needs.
First we have the directory input_data where you can store your data which needs to be analyzed. The data should be processed after base calling and should be formatted in `fastq.gz`.

### sample names
The sample names should be in the **sample_names.yml** file. In this file there are brackets after the IDs: where you should write down your sample names without the fastq.gz part. separate the samples with a comma between the brackets to create your sample list. These names will be used to make sure every sample goes through the pipeline and the results get named to the sample name you provided.

### Trimming settings
If you want to tweak the Trimming settings from the chopper tool open the Snakefile with nano:
```bash
nano Snakefile
```
Go to the rule filtering_data: In this rule the shell code can be edited for your needs. Only the part between the pipes can be edited. If you want to change different parameters you can consult the [chopper](https://github.com/wdecoster/chopper) documentation.

### kraken data base settings

Building the data base for kraken cost a lot of computing power. In this workflow the threads used for building the data base is set on 10 threads. When you want to change the amount of threads open the scripts directory and edit with nano the script to your needs.


### Reference sequences database
In the reference_sequences directory are 8 different COI genes from different tick species. These 8 species are the most commen in the Netherlands. If you want to test your data against more species you will need to search for COI reference genes of the species of choise.
After you found and downloaded the sequence of the COI gene in fasta format, put the sequence in the reference_sequennces directory.

## using the workflow
Go to the Tick_determination directory, when you are in the directory check if the Snakefile is pressent using the command `ls`.
Before you can start the workflow activate the snakemake environment:
```bash
conda activate snakemake
```
to start the workflow simply use the comand:
```bash
snakemake -c8 --use-conda
```
adjust the -c number to the amount of threads you want to use for the workflow in this case its set on 8.
