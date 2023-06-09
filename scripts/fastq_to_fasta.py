import sys

fastq_file = sys.argv[1]  # Input FASTQ file
fasta_file = sys.argv[2]  # Output FASTA file

with open(fastq_file, 'r') as fastq, open(fasta_file, 'w') as fasta:
    sequence = ""
    for line in fastq:
        line.upper()
        if line.startswith('@'):  # FASTQ header line
            seq_id = line.strip()[1:]
            seq_id.replace('@', '')
            fasta.write('>' + seq_id + '\n')  # Write FASTA header
        elif line.startswith('A') or line.startswith('T') or line.startswith('G') or line.startswith('C'):  # Sequence line
            sequence = line.strip()  # Store the sequence
            fasta.write(sequence)  # Write sequence line
