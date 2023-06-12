# Tick determination
A snakemake pipeline for tick determination from ONT whole genome sequencing samples (after basecalling).

## What does this pipeline do?

## downloading the pipeline
use `wget https://github.com/sergio2447/Tick-determination/archive/refs/heads/main.zip > Tick_determination.zip`  to download this repository from github and unzip the file with `unzip Tick_determination.zip`

## Installing miniconda
download minicondas`curl -O https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh`. After the file is downloaded use `bash Miniconda3-py310_23.3.1-0-Linux-x86_64.sh` to install miniconda3. Keep in mind that python 3.10 is required to install miniconda3.
At the end of the instalation there will be a request to download conda init. Please type **"yes"** here. This will add some code to your .bashrc file, which is important to work with correctly.
**Please close and reopen the terminal, to complete the installation.**

### updating and instaling conda changels
after closing and reopening the terminal you should be able tu update conda: `conda update --yes conda`.

## creating a snake make environment
for creating 
