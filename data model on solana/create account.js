const solanaWeb3 = require('@solana/web3.js');
const fs = require("fs")
const { Keypair, Connection, SystemProgram, Transaction, sendAndConfirmTransaction } = solanaWeb3;

// Connect to Solana devnet
const connection = new Connection(solanaWeb3.clusterApiUrl('devnet'), 'confirmed');

// Generate a new keypair for the data account
const dataAccount = Keypair.generate();
const payer = Keypair.fromSecretKey(new Uint8Array(JSON.parse(fs.readFileSync(`/Users/harkiratsingh/.config/solana/id.json`, "utf-8")))); // This will be the account paying for the transaction

async function createAccount() {
    // Create a transaction to create and fund the account
    const tx = new Transaction().add(
        SystemProgram.createAccount({
            fromPubkey: payer.publicKey,
            newAccountPubkey: dataAccount.publicKey,
            lamports: await connection.getMinimumBalanceForRentExemption(1000), // Amount to fund the account
            space: 1000, // Space in bytes to allocate for data
            programId: SystemProgram.programId,
        })
    );

    // Send the transaction to the network
    const txId = await sendAndConfirmTransaction(connection, tx, [payer, dataAccount]);

    console.log(`Created account with transaction ID: ${txId}`);

}

createAccount();