# I'm Open Sourcing this because I no longer need it. I've had my fun. Good Luck Everyone.

# Creating a Solana Token

This guide outlines the steps for creating a Solana token using command line tools. Each step is critical in ensuring the successful creation, deployment, and management of the token.

## Prerequisites

- Ensure you have Solana's CLI tools installed.
  - These commands should work on your CLI:
    - `solana-keygen`
    - `solana`
    - `spl-token`
- Have Node.js and `ts-node` installed for running scripts.
- Ensure you have a way to get files onto ARWeave for storing metadata. We'll be using this site for that: [https://solana.keyglowmax.com/fileuploader](https://solana.keyglowmax.com/fileuploader)
  - _Note: Not sure this site is free of viruses, only connect burner wallets with ~0.25 SOL (Each upload costs 0.11 SOL)_

## Part One: Essential Setup

### Creative

- Name
  - INSERT
- Symbol
  - INSERT
- Description
  - INSERT
- Create /Media folder
  - Profile in 1:1 Ratio (Name this: Icon.xxx)
  - Twitter Banner (Name this: Banner.xxx)
  - "New Token Buy!" Gif (Name this: BuyGif.gif)
  - 3 Good Tweets
    - Tweet 1:
    - Tweet 2:
    - Tweet 3:

#### Technical

- Porkbun — Buy Domain
- Framer — Build Website
  - Create Main Site
  - Change Favicon
  - Change Title Text
- Twitter — Create twitter
- Telegram — Ensure telegram is thoroughly scrubbed, then create new persona
- Setup Telegram Portal & Group with @Safeguard

## Part Two: Launching Token

### Step 1: Generate Deployer Address

Generate a unique deployer address that starts with a specific prefix using `solana-keygen`.

```bash
solana-keygen grind --starts-with Dep1:1
```

### Step 2: Generate Token Address

Similarly, create a token address with a specific prefix.

```bash
solana-keygen grind --starts-with TOK:1
```

### Step 3: Set Network to Mainnet

Configure Solana CLI to use the mainnet and specify your deployer keypair.

```bash
solana config set -um -k Dep1.json
```

### Step 4: Fund Deployer Address

Transfer SOL to your deployer address to fund the token creation and transactions.

### Step 5: Create Token Address

Create the token using your specified token address stored in `TOK.json`.

```bash
spl-token create-token TOK.json
```

### Step 6: Manage Metadata on Arweave

- **Upload Image:** Upload your token's image (The 1:1 Ratio Pic) to Arweave.
- **Edit Metadata:** Ensure your `metadata.json` is accurate and up to date.
- **Upload Metadata:** Upload the edited `metadata.json` to Arweave.

### Step 7: Deploy Metadata

Utilize the script to attach metadata to your token.

```bash
ts-node mpl_metadata.ts Dep1.json TOK "Name" "Symbol" "uri"
```

**Example:**

```bash
ts-node mpl_metadata.ts GWTviHhoatDtB7QyTXsk3Gwe6Kufnmf8ESaAiTHo7Chc.json BBLCOINCcsJV7UjK5qCy4xxxxxxxbo1j487Tg3 "BUBBLEMOONCOIN" "BUBBL" "https://arweave.net/xyz"
```

Include links (website, Telegram, Twitter, etc.) in the description for better visibility on scanners. Performing a few transactions from the wallet ahead of deploying can help avoid the "Fresh Wallet" flag on scanners.

### Step 8: Update Public Information

Update project's website with
-Token Address
-Telegram
-Twitter

### Step 9: Minting Tokens

For token minting, use the provided script instead of direct SPL Token CLI commands.

```bash
chmod +x create_and_mint.sh
./create_and_mint.sh <TOKEN_ADDRESS>
```

### Step 10: Secure Token

Disable further minting and freezing of the token. Also, set the metadata to be immutable.

```bash
chmod +x freeze_and_revoke.sh
./freeze_and_revoke.sh TOK Dep1.json
```

**SAVE MINT REVOKE TXN FOR LATER**

### Step 11: Dev Wallets

10% of the token will be distributed to developer wallets.

```bash
chmod +x distribute_devtokens.sh
./distribute_devtokens.sh NUM_OF_WALLETS TOK Dep1.json
```

## Part Three: Setup Telegram

_This needs better documentation, when you're creating this, write exactly what steps you took._

Setup Bots:

- @MissRose_bot
  - `/filter`
    - ca TOK
    - website SITE
    - twitter TWITTER
    - revoke MINT_TXN
    - chart dexscreener.com/solana/TOK
  - `/setwelcome` Hey, {first}. Welcome to NAME!!! Enjoy your stay
  - `/goodbye` false
- @D.BuyBot
- @chattershield_bot

_It's at this part that people may start flooding into your telegram. BUCKLE UP._

## Part Four: Create Market

Market Creation: [http://openbook-explorer.xyz](http://openbook-explorer.xyz)

Here's an example: [https://openbook-explorer.xyz/market/9DEvcGnwJpY9KPxKqgep1Dk59edwzFxozQXMfQUSH6y4](https://openbook-explorer.xyz/market/9DEvcGnwJpY9KPxKqgep1Dk59edwzFxozQXMfQUSH6y4)

- Existing
  - For base mint use TOK,
  - For quote mint use So11111111111111111111111111111111111111112
- Min order size: -3
- Price Tick: 9

**Add Liq.** (Seems like 11 SOL is the meta rn)

### Part Five: Manage the Public

**TWEET 1**

- Launch Pre-Made Tweet #1

**Build Hype**

- Chill with the community for a while, really get down & hype them up.

**BURN COMMAND**

```bash
spl-token burn tokenAccountAddress 50
```

**TWEET 2**

- Tweet BURN

**Telegram Pin**

- Pin BURN

- `/filter ca BURN`

**TWEET 3**

- Launch Pre-Made Tweet #2
- SHIELD & get likes

**Community Shill**

- Ask people to find accounts to post under
- Tweet under a few "Shill me coin" accounts
- Shield

**TWEET 4**

- Launch Pre-Made Tweet #3
- Shield

## Shitcoin Tips!

There should be a sniper candle at some point where your coin goes 3x in the span of like, 2 transactions. THIS IS THE POINT WHERE YOU SHOULD SELL TO BREAK EVEN

- Do your first sell on initial sniper call to get your initial money back.
- Sell slowly on second pump to fund the callers.
