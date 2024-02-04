#!/bin/bash

# Check if we got the expected number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <token_address> <Dep1_file_with_extension>"
    exit 1
fi

# Assign the first argument to a variable for the token address
token_address=$1
# Assign the second argument to a variable for the keypair file
Dep1=$2

echo "Disabling mint for token at address: $token_address"
spl-token authorize $token_address mint --disable

echo "Attempting to disable freeze for token at address: $token_address"
spl-token authorize $token_address freeze --disable

echo "Setting metadata to immutable for keypair file: $Dep1"
metaboss set immutable --keypair $Dep1 --account $token_address

echo "Token Permissions have been frozen and revoked."
echo "------"
echo "SAVE DISABLE MINT TXN"