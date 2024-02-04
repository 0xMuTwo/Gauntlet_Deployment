#!/bin/bash

# Make sure a token address is passed as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <TOKEN_ADDRESS>"
    exit 1
fi

TOK=$1

# First, create the account for the token
spl-token create-account $TOK

# Then, mint to the token account
spl-token mint $TOK 1000000000

echo "Token account created and tokens minted successfully."