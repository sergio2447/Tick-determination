configfile: "sample_names.yml"
IDlist = config["IDs"]

rule all:
    input:
        expand("output_data/nanoplot_raw_data/{sample}", sample=IDlist),
        expand("output_data/filterd_data/filterd_{sample}.fastq.gz", sample=IDlist),
        expand("output_data/nanoplot_filterd_data/{sample}", sample=IDlist),
        expand("output_data/minimap2_data/aln_{sample}.sam", sample=IDlist),
        expand("output_data/samtools_data/extracted_reads_{sample}.bam", sample=IDlist),
        expand("output_data/samtools_data/consensus_{sample}.fastq",sample=IDlist),
        expand("output_data/consensus_and_kraken_data/consensus_{sample}.fasta", sample=IDlist),
        expand("output_data/consensus_and_kraken_data/Tick_library/taxonomy/readme.txt"),
        expand("output_data/Results/consensus_and_kraken_data/species_{sample}.txt", sample=IDlist)

rule nanoplot_raw:
    input:
        "input_data/{sample}.fastq.gz"
    output:
        dir = directory("output_data/nanoplot_raw_data/{sample}")
    conda:
        "envs/nanoplot.yml"
    shell:
        "NanoPlot --verbose --fastq {input} -o {output.dir}"

rule filtering_data:
    input:
        "input_data/{sample}.fastq.gz"
    output:
        "output_data/filterd_data/filterd_{sample}.fastq.gz"
    conda:
        "envs/chopper.yml"
    shell:
        "gunzip -c {input} | chopper -q 10 -l 1000 | gzip > {output}"

rule nanoplot_filterd:
    input:
        "output_data/filterd_data/filterd_{sample}.fastq.gz"
    output:
        dir = directory("output_data/nanoplot_filterd_data/{sample}")
    conda:
        "envs/nanoplot.yml"
    shell:
        "NanoPlot --verbose --fastq {input} -o {output.dir}"

rule minimap2:
    input:
        "output_data/filterd_data/filterd_{sample}.fastq.gz"
    output:
        "output_data/minimap2_data/aln_{sample}.sam"
    conda:
        "envs/minimap2.yml"
    shell:
        "minimap2 -ax map-ont reference_sequences/all_referencesCO1.fasta {input} > {output}"

rule samtools:
    input: 
        "output_data/minimap2_data/aln_{sample}.sam"
    output:
        "output_data/samtools_data/extracted_reads_{sample}.bam"
    conda:
        "envs/samtools.yml"
    shell:
        "samtools view -Sb -o output_data/samtools_data/aln_{wildcards.sample}.bam {input} && samtools flagstats output_data/samtools_data/aln_{wildcards.sample}.bam > output_data/Results/flagstats_aln_{wildcards.sample}.txt \
&& samtools sort output_data/samtools_data/aln_{wildcards.sample}.bam -o output_data/samtools_data/aln_sorted_{wildcards.sample}.bam && samtools index output_data/samtools_data/aln_sorted_{wildcards.sample}.bam \
&& samtools view -b -F 4 output_data/samtools_data/aln_sorted_{wildcards.sample}.bam > {output} && \
samtools flagstats output_data/samtools_data/extracted_reads_{wildcards.sample}.bam > output_data/Results/flagstats_extracted_{wildcards.sample}.txt"

rule bcftools:
    input: 
        "output_data/samtools_data/extracted_reads_{sample}.bam"
    output:
        "output_data/samtools_data/consensus_{sample}.fastq"
    conda:
        "envs/samtools.yml"
    shell:
        "bcftools mpileup -f reference_sequences/all_referencesCO1.fasta {input} | bcftools call -c | vcfutils.pl vcf2fq > {output}"

rule transformer:
    input: 
        "output_data/samtools_data/consensus_{sample}.fastq"
    output:
        "output_data/consensus_and_kraken_data/consensus_{sample}.fasta"
    shell:
        "python3 scripts/fastq_to_fasta.py {input} {output}"

rule kraken database:
    input:
        "reference_sequences/Ixodes_ricinus_CO1ref.fasta"
    output:
        "output_data/consensus_and_kraken_data/Tick_library/taxonomy/readme.txt"
    conda:
        "envs/kraken.yml"
    shell:
        "bash scripts/kraken_database.sh"

rule kraken report:
    input:
        "output_data/consensus_and_kraken_data/Tick_library/taxonomy/readme.txt",
        "output_data/consensus_and_kraken_data/consensus_{sample}.fasta"
    output:
        "output_data/Results/consensus_and_kraken_data/species_{sample}.txt"
    conda:
        "envs/kraken.yml"
    shell:
        "kraken --db output_data/consensus_and_kraken_data/Tick_library --thread 10 --output output_data/consensus_and_kraken_data/species_{wildcards.sample}.kraken --fasta-input output_data/consensus_and_kraken_data/consensus_{wildcards.sample}.fasta && \
 kraken-report --db output_data/consensus_and_kraken_data/Tick_library output_data/consensus_and_kraken_data/species_{wildcards.sample}.kraken > {output} "
    
