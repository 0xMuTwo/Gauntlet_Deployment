import {Collection, CreateMetadataAccountV3InstructionAccounts, CreateMetadataAccountV3InstructionDataArgs, Creator, Uses, createMetadataAccountV3} from "@metaplex-foundation/mpl-token-metadata";
import * as web3 from "@solana/web3.js";
import { createSignerFromKeypair, none, signerIdentity } from "@metaplex-foundation/umi";
import { createUmi } from '@metaplex-foundation/umi-bundle-defaults';
import { fromWeb3JsKeypair, fromWeb3JsPublicKey} from '@metaplex-foundation/umi-web3js-adapters';
import { bs58 } from "@project-serum/anchor/dist/cjs/utils/bytes";

export function loadWalletKey(keypairFile:string): web3.Keypair {
    const fs = require("fs");
    const loaded = web3.Keypair.fromSecretKey(
      new Uint8Array(JSON.parse(fs.readFileSync(keypairFile).toString())),
    );
    return loaded;
  }


async function main() {
    if (process.argv.length < 7) {  // Check if enough arguments are provided
        console.error('Usage: ts-node mpl_metadata.ts [Dep1.json] [TOK] [name] [symbol] [uri]');
        process.exit(1);
    }
    const importedKeypair = process.argv[2];
    const importedMint = process.argv[3];
    const name = process.argv[4];
    const symbol = process.argv[5];
    const uri = process.argv[6];
    
    console.log(`Values:\n- Deployer Address File: ${importedKeypair}\n- Token Address: ${importedMint}\n- Name: ${name}\n- Symbol: ${symbol}\n- URI: ${uri}\n\n`);
    
    console.log("Running Token Generation...\n");
    const myKeypair = loadWalletKey(importedKeypair);
    const mint = new web3.PublicKey(importedMint);

    const umi = createUmi("https://mainnet.helius-rpc.com/?api-key=c290f545-b68d-4271-a604-0b77337fa8dd");
    const signer = createSignerFromKeypair(umi, fromWeb3JsKeypair(myKeypair))
    umi.use(signerIdentity(signer, true))

    // Utilize the provided metadata from command line arguments
    const ourMetadata = {
        name: name,
        symbol: symbol,
        uri: uri,
    }
    const onChainData = {
        ...ourMetadata,
        sellerFeeBasisPoints: 0,
        creators: none<Creator[]>(),
        collection: none<Collection>(),
        uses: none<Uses>(),
    }
    const accounts: CreateMetadataAccountV3InstructionAccounts = {
        mint: fromWeb3JsPublicKey(mint),
        mintAuthority: signer,
    }
    const data: CreateMetadataAccountV3InstructionDataArgs = {
        isMutable: true,
        collectionDetails: null,
        data: onChainData
    }
    const txid = await createMetadataAccountV3(umi, {...accounts, ...data}).sendAndConfirm(umi);
    const decodedTx = bs58.encode(txid.signature)
    console.log(`Confirmed: https://solscan.io/tx/${decodedTx}`)
}

main();