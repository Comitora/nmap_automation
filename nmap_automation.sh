#!/bin/bash

# Script to automate the recon process using nmap

# Get input file containing list of URLs
input_file=$1

# Create a new file to store the cleaned URLs
cleaned_file="cleaned_$input_file"

# Remove "http://" and "https://" from the URLs
sed 's/https:\/\///g;s/http:\/\///g' "$input_file" > "$cleaned_file"

# Iterate through each cleaned URL in the new file
while read -r url; do
    # Check if host is up
    echo "Scanning $url"
    if nmap -sP "$url" | grep "Host is up" > /dev/null; then
        # If host is up, scan all open ports, version detection and verbose output
        nmap -vv -sCV "$url" >> nmap_scan.txt
    else
        # If host is down, use -Pn flag, version detection and verbose output
        nmap -vv -sCV -Pn "$url" >> nmap_scan.txt
    fi
done < "$cleaned_file"

echo "Cleaned URLs are stored in $cleaned_file"
echo "Nmap
