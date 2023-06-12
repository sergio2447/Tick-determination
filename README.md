# Tick determination
A snakemake pipeline for tick determination from ONT whole genome sequencing samples (after basecalling).

## What does this pipeline do?

## downloading the pipeline
Use `wget https://github.com/sergio2447/Tick-determination/archive/refs/heads/main.zip > Tick_determination.zip`  to download this repository from github and unzip the file with `unzip Tick_determination.zip`

## Installing miniconda
Download miniconda3: `curl -O https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh`.

After the file is downloaded use `bash Miniconda3-py310_23.3.1-0-Linux-x86_64.sh` to install miniconda3. Keep in mind that python 3.10 is required to install miniconda3.

At the end of the instalation there will be a request to download conda init. Please type **"yes"** here. This will add some code to your .bashrc file, which is important to work with correctly.

**Please close and reopen the terminal, to complete the installation.**

### updating and instaling conda changels
After closing and reopening the terminal you should be able tu update conda: `conda update --yes conda`.
When its done updating download the following chanels:

`conda config --add channels defaults`

`conda config --add channels bioconda`

`conda config --add channels conda-forge`

### creating a snake make environment
For creating the snakemake environment you should use this in the terminal: `conda create -n snakemake -c bioconda snakemake python=3.10 `.  After this environment is created use `conda activate snakemake` to activate the environment.

