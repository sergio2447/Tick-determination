# Tick determination
A Snakemake pipeline for tick determination from ONT metagenomic sequencing samples (after base calling).

## Introduction
This workflow is created for tick species determination on wild birds in the Netherlands. Avans students generated the metagenomic data received to test the workflow, and the ticks were harvested from birds by Erasmus University. This project is a collaboration of Avans with Erasmus University and One Health Pact.

In the Snakemake workflow, using a set of tools will lead to species identification.
1. First, the quality of the raw ONT reads is assessed with Nanoplot. 
2. The raw reads are filtered using Chopper.
3. The filtered reads are also checked on quality using Nanoplot.
4. With Minimap2, the filtered ONT reads are mapped against the reference sequences using the map-ont mode.
5. Samtools is used to manipulate the .sam output of Minimap2. Samtools does the converting to a bam file, indexing, sorting, and extracting of the mapped reads. It also provides flagstats so the user can see how many reads are mapped and extracted.
6. BCFtools is used to make a consensus from the mapped reads, which can be analyzed using Kraken. The consensus sequence is transformed from a fastq file to a fasa file using the python script [fastq_to_fasta.py](https://github.com/sergio2447/Tick-determination/blob/main/scripts/fastq_to_fasta.py) in the scripts directory
7. Lastly, Kraken is used to build a database with COI reference sequences of choice. The consensus sequence is aligned against the database, and Kraken assigns taxonomic labels to the consensus sequences.  


## Workflow

![Workflow](https://github.com/sergio2447/Tick-determination/blob/main/Blank%20diagram.png)

## Input and output

### Input data

The input data consists of Oxford nanopore sequencing data after base calling. The data format should be in fastq.gz. Every fastq.gz file that needs to be analyzed by this workflow should be in the input_data directory.

### Output directories
All the output directories can be found in the output_data directory.
1. nanoplot_raw_data: Contains the Nanoplot results of the raw samples. Download the NanoPlot-report file to check the read quality and read length. 
2. nanoplot_filterd_data: Contains the Nanoplot results of the filtered samples. Download the NanoPlot-report file to check the read quality and read length. 
3. filterd_data: The data after filtering is stored in this directory.
4. minimap2_data: The mapped reads are stored in sam format in this directory.
5. samtools_data: The sorted and transformed files to extract the mapped reads are stored in this directory. The consensus sequence in fastq format is also stored here.
6. consensus_and_kraken_data: The consensus sequence in fasta format and the Kraken output can be found in this directory.
7. results: This directory contains two txt files per sample by samtools flagstats. The files show how many reads are mapped and how many reads are extracted for creating a consensus. The results from the alignment of the consensus to the database of reference sequences using Kraken are also in this directory. This result is stored in a txt file which contains the species classification.

## ⚙️ Installation

### Downloading the pipeline
For downloading the pipeline use:
```bash
wget https://github.com/sergio2447/Tick-determination/archive/refs/heads/main.zip > Tick_determination.zip
```
To download this repository from GitHub and unzip the file use:  
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
This installs miniconda3. Keep in mind that Python 3.10 is required to install this version of miniconda3.

At the end of the installation there will be a request to download conda init. Please type **"yes"** here. This will add some code to your .bashrc file, which is important to work with this workflow correctly.

**Please close and reopen the terminal, to complete the installation.**

### Updating and installing conda channels
After closing and reopening the terminal you should be able to update conda: `conda update --yes conda`.
When it is done updating download the following channels:

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

### Creating a Snakemake environment
For creating the Snakemake environment use this in the terminal: 
```bash
conda create -n snakemake -c bioconda snakemake python=3.10
```
After this environment is created use `conda activate snakemake` to activate the environment.

## Configurating the pipeline to your needs.
For the configuration of the pipeline there are several parts that can be tweaked to the user's preferences.
First, the data needs to be stored in the directory input_data in fastq.gz format. 

### Sample names
The sample names should be in the **sample_names.yml** file. This file contains empty brackets after the IDs where sample names need to be inserted without the fastq.gz part. Separate the samples with a comma between the brackets to create the sample list. These names will be used to make sure every sample goes through the pipeline, and the results get named to the sample name provided by the user.

### Trimming settings
If you want to tweak the settings for trimming by the Chopper tool open the Snakefile with nano:
```bash
nano Snakefile
```
Go to the rule filtering_data: In this rule the shell code can be adjusted to the user's needs. Only change the part between the two pipes for adding or adjusting the parameters. Consult the [chopper](https://github.com/wdecoster/chopper) documentation for adjusting or adding parameters.

### Kraken settings
For making the alignment the number of threads is set to 10. If more or less threads are needed change this in the Snakefile.
Open the Snakefile with nano:
```bash
nano Snakefile
```
Go to rule kraken report and edit in the shell part the --threads to the desired number.

### Kraken database
The reference_sequences directory contains 8 COI sequences from different tick species, which are the most common tick species found in the Netherlands. If species need to be added to the list, search for other COI sequences from additional species of choice. Download the sequences in fasta format of choice and add to the reference_sequences directory. This workflow is designed for determination of tick species using the COI barcoding gene, however when providing the references other organisms or alternative barcoding genes might also be applicable with this workflow. 

## Using the workflow
Go to the Tick_determination directory, and check if the Snakefile is present using the command `ls`.
Before starting the workflow activate the Snakemake environment:
```bash
conda activate snakemake
```
To start the workflow use the command:
```bash
snakemake -c8 --use-conda
```
The value of -c can be adjusted to a different number of threads that the user might prefer. 

### Useful snakemake parameters

| Short Option | Long Option | Explanation |
| :------ | :------ | :---------- |
| `-k` | `--keep` | If a job fails, continue with independent jobs. |
| `-p` | `--printshellcmds` | Print out the shell commands that will be executed. |
| `-r` | `--reason` | Print the reason for rule execution (Missing output, updated input etc.) |
| `-c` | `--cores` | Number of CPU cores (threads) to use for this run. With no int, it uses all. |
| `--ri` | `--rerun-incomplete` | If Snakemake marked a file as incomplete after a crash, delete and produce it again. |
| `-n` | `--dryrun` | Just pretend to run the workflow. A similar option is `-S` (`--summary`). |
| `-q` | `--quiet` | Do not output certain information. If used without arguments, do not output any progress or rule information. |
|      | `--cleanup-shadow` | Cleanup old shadow directories which have not been deleted due to failures or power loss. |
|      | `--verbose` | Print detailed stack traces and detailed operations. Default is False. |
|      | `--nocolor` | Do not use a colored output. Default is False. |

