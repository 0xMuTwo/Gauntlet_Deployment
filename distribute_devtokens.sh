#!/bin/bash
# Takes in a deployer wallet with tokens, then distributes them to generated wallets

# Checks for the correct number of arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 num_wallets token_address new_keypair_path"
    exit 1
fi

total_amount=100000000 # Configurable: Total tokens to distribute

token_address=$2   # The token address argument
new_keypair_path=$3    # The new keypair path argument
config_file_name="config.yml"   # Configurable: name/path for the config file

# Saves the current directory of the script
script_dir=$(pwd)

# Creates the full path to the configuration file
config_path="$script_dir/$config_file_name"

# Ensures that the new_keypair_path is an absolute path
if [[ "$new_keypair_path" != /* ]]; then
    new_keypair_path="$script_dir/$new_keypair_path"
fi

# Updates the keypair path in the config file
sed -i '' "s|keypair_path: .*|keypair_path: $new_keypair_path|" "$config_path" || {
    echo "Failed to update keypair path in config"
    exit 1
}

echo "Updated keypair in config.yml to $new_keypair_path"

# Prepares directories for storing wallet files
dev_wallets_dir="$script_dir/devWallets"
funded_wallets_dir="$script_dir/fundedWallets"
mkdir -p "$dev_wallets_dir" "$funded_wallets_dir"

# Generates wallets if none exist
num_dev_wallets=$(ls -1 "$dev_wallets_dir"/*.json 2>/dev/null | wc -l)
num_funded_wallets=$(ls -1 "$funded_wallets_dir"/*.json 2>/dev/null | wc -l)
if [ $((num_dev_wallets + num_funded_wallets)) -eq 0 ]; then
    echo "No wallets detected in 'devWallets' or 'fundedWallets'. Generating $1 wallets..."
    cd "$dev_wallets_dir"
    solana-keygen grind --ends-with d:$1
    cd "$script_dir"
fi

# Performs necessary checks and executes token distribution
num_dev_wallets=$(ls -1 "$dev_wallets_dir"/*.json 2>/dev/null | wc -l) # Update the count after potential generation
total_wallets=$((num_dev_wallets + num_funded_wallets))
if [ $total_wallets -eq $1 ] && [ $num_dev_wallets -eq 0 ]; then
    echo "Operation has been completed. All $1 wallets have been funded."
    exit 0
elif [ $total_wallets -eq 0 ]; then
    echo "Failed to generate any wallets. Please check for potential issues."
    exit 1
fi

transfer_amount=$((total_amount / total_wallets))
echo "Distributing $total_amount tokens evenly across all wallets (${transfer_amount} tokens each)..."

cd "$dev_wallets_dir" || { echo "Failed to change directory to devWallets"; exit 1; }
for wallet_file in *.json; do
    if [ -f "$wallet_file" ]; then
        dev_address=$(solana-keygen pubkey "$wallet_file")
        echo "Transferring ${transfer_amount} tokens to $dev_address from $token_address"
        if spl-token transfer --allow-unfunded-recipient --fund-recipient --config "$config_path" $token_address $transfer_amount $dev_address; then
            echo "Transfer to $dev_address successful."
            mv "$wallet_file" "$funded_wallets_dir/"
        else
            echo "Transfer to $dev_address failed."
        fi
    fi
done

echo "All transfers completed."