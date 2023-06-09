cd ../output_data/consensus_and_kraken_data
excluded="all_referencesCO1.fasta"
kraken-build --download-taxonomy --db Tick_library
for file in ../../reference_sequences/*.fasta; do
    if [[ "$file" == *"$excluded" ]]; then
        continue
    fi 
        kraken-build --add-to-library $file --db Tick_library
done

kraken-build --build --db Tick_library