#!/bin/bash

# Usage: ./dns_brute.sh domains.txt wordlists_dir
# $1 -> file containing domains (one per line)
# $2 -> directory containing .txt wordlists

DOMAINS_FILE="$1"
WORDLIST_DIR="$2"
OUTPUT_FILE="subs-brute"

if [[ ! -f "$DOMAINS_FILE" ]]; then
    echo "❌ Domains file not found: $DOMAINS_FILE"
    exit 1
fi

if [[ ! -d "$WORDLIST_DIR" ]]; then
    echo "❌ Wordlist directory not found: $WORDLIST_DIR"
    exit 1
fi

while read -r DOMAIN; do
    [[ -z "$DOMAIN" ]] && continue  # skip empty lines

    for WORDLIST in "$WORDLIST_DIR"/*.txt; do
        echo "🔍 Running Gobuster on $DOMAIN with $WORDLIST"
        gobuster dns \
            --domain "$DOMAIN" \
            --wildcard \
            -w "$WORDLIST" -o subz
        echo "---------------------------------" | tee -a "$OUTPUT_FILE"
    done

done < "$DOMAINS_FILE"
