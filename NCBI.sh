#!/bin/bash

# Path of this script: sbatch /home/zzeng/git_hub/scripts/pseudomonasAnalysis/NCBI.sh

input_file="/home/zzeng/scratch/NameList/PG2dRef"
output_file="gcf_metadata_Pub.csv"

echo "Accession,BioSample_Accession,BioProject_Accession,Organism,Strain,Host,Isolation_Source,Collection_Date,Location,Assembly_Release_Date,BioSample_Submission_Date,BioSample_Publication_Date,Publication_Titles,PubMed_IDs" > "$output_file"

while read -r acc; do
    [ -z "$acc" ] && continue
    echo "🔍 Fetching $acc..."

    json=$(datasets summary genome accession "$acc")

    organism=$(echo "$json" | jq -r '.reports[0].organism.organism_name // "NA"')
    strain=$(echo "$json" | jq -r '.reports[0].organism.infraspecific_names.strain // "NA"')

    biosample_acc=$(echo "$json" | jq -r '.reports[0].assembly_info.biosample.accession // "NA"')
    bioproject_acc=$(echo "$json" | jq -r '.reports[0].assembly_info.bioproject_accession // "NA"')

    host=$(echo "$json" | jq -r '.reports[0].assembly_info.biosample.attributes[]? | select(.name == "host") | .value' | head -n 1)
    isolation_source=$(echo "$json" | jq -r '.reports[0].assembly_info.biosample.attributes[]? | select(.name == "isolation_source") | .value' | head -n 1)
    collection_date=$(echo "$json" | jq -r '.reports[0].assembly_info.biosample.attributes[]? | select(.name == "collection_date") | .value' | head -n 1)
    location=$(echo "$json" | jq -r '.reports[0].assembly_info.biosample.attributes[]? | select(.name == "geo_loc_name") | .value' | head -n 1)

    release_date=$(echo "$json" | jq -r '.reports[0].assembly_info.release_date // "NA"')
    biosample_submission_date=$(echo "$json" | jq -r '.reports[0].assembly_info.biosample.submission_date // "NA"')
    biosample_publication_date=$(echo "$json" | jq -r '.reports[0].assembly_info.biosample.publication_date // "NA"')

    # Step 1: Try genome-level publications from datasets
    pub_titles=$(echo "$json" | jq -r '[.reports[0].references[]?.title] | join("; ") // empty')
    pubmed_ids=$(echo "$json" | jq -r '[.reports[0].references[]?.pubmed_id] | join(",") // empty')

    # Step 2: Scrape publication info from BioProject web page if still empty
    if [[ -z "$pub_titles" && "$bioproject_acc" != "NA" ]]; then
        echo "  ↪ No structured refs — scraping BioProject page for $bioproject_acc"

     # Strip "PRJNA" prefix if present
        numeric_bp=$(echo "$bioproject_acc" | grep -o '[0-9]*')

        pub_titles=$(curl -s "https://www.ncbi.nlm.nih.gov/bioproject/$numeric_bp" \
            | grep -A 5 -i 'Publications' \
            | grep -oP '(?<=<dd>).*?(?=</dd>)' \
            | paste -sd "; " -)

        pub_titles=${pub_titles:-NA}
        pubmed_ids="NA"
    fi

    # Normalize remaining fields
    host=${host:-NA}
    isolation_source=${isolation_source:-NA}
    collection_date=${collection_date:-NA}
    location=${location:-NA}
    pub_titles=${pub_titles:-NA}
    pubmed_ids=${pubmed_ids:-NA}

    echo "$acc,\"$biosample_acc\",\"$bioproject_acc\",\"$organism\",\"$strain\",\"$host\",\"$isolation_source\",\"$collection_date\",\"$location\",\"$release_date\",\"$biosample_submission_date\",\"$biosample_publication_date\",\"$pub_titles\",\"$pubmed_ids\"" >> "$output_file"
done < "$input_file"

echo "✅ Done! Metadata saved to $output_file"
