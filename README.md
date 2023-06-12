# Tick determination
A snakemake pipeline for tick determination from ONT whole genome sequencing samples (after basecalling).

## Introduction

## 🐍 Workflow

## instalations

### downloading the pipeline
Use `wget https://github.com/sergio2447/Tick-determination/archive/refs/heads/main.zip > Tick_determination.zip`  to download this repository from github and unzip the file with `unzip Tick_determination.zip`

### Installing miniconda
Download miniconda3: `curl -O https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh`.

After the file is downloaded use `bash Miniconda3-py310_23.3.1-0-Linux-x86_64.sh` to install miniconda3. Keep in mind that python 3.10 is required to install miniconda3.

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
For creating the snakemake environment you should use this in the terminal: `conda create -n snakemake -c bioconda snakemake python=3.10 `.  After this environment is created use `conda activate snakemake` to activate the environment.

## configurating the pipeline to your needs.
For the configuration of the pipeline there are several parts which can be tweaked for your own needs.
First we have the directory input_data where you can store your data which needs to be analyzed. The data should be processed after base calling and should be formatted in `fastq.gz`.

### sample names
The sample names should be in the **sample_names.yml** file. In this file there are brackets after the IDs: where you should write down your sample names without the fastq.gz part. separate the samples with a comma between the brackets to create your sample list. These names will be used to make sure every sample goes through the pipeline and the results get named to the sample name you provided.

### Trimming settings
If you want to tweak the Trimming settings from the chopper tool open the Snakefile with nano `nano Snakefile`. Go to the rule filtering_data: In this rule the shell 
