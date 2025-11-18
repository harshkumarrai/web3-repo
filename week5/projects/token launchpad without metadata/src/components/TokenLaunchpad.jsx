import { createInitializeMint2Instruction, createMint, getMinimumBalanceForRentExemptAccount, getMinimumBalanceForRentExemptMint, TOKEN_PROGRAM_ID } from "@solana/spl-token";
// import { useConnection, useWallet } from "@solana/wallet-adapter-react/lib/types";
import { useConnection, useWallet } from "@solana/wallet-adapter-react";
import { MINT_SIZE } from "@solana/spl-token";

import { Connection, Keypair, SystemProgram, Transaction } from "@solana/web3.js";

export function TokenLaunchpad() {
    const {connection}=useConnection();
const wallet=useWallet();
async function createtoken(){

    const name=document.getElementById("name").value;
    const symbol=document.getElementById("symbol").value;
    const image=document.getElementById("image").value;
    const supply=document.getElementById("supply").value;
    const lamports=await getMinimumBalanceForRentExemptMint(connection);
    const mintKeypair=Keypair.generate();
    const transaction=new Transaction().add(
         SystemProgram.createAccount({
            fromPubkey: wallet.publicKey,
            newAccountPubkey: mintKeypair.publicKey,
            space: MINT_SIZE,
            lamports,
            programId:TOKEN_PROGRAM_ID,
        }),
                createInitializeMint2Instruction(mintKeypair.publicKey, 6, wallet.publicKey, wallet.publicKey, TOKEN_PROGRAM_ID)
        

    );
      transaction.feePayer = wallet.publicKey;
        transaction.recentBlockhash = (await connection.getLatestBlockhash()).blockhash;
        transaction.partialSign(mintKeypair);

        await wallet.sendTransaction(transaction, connection);
        console.log(`Token mint created at ${mintKeypair.publicKey.toBase58()}`);

     

}
    return  <div className="topper">
        <h1>Solana Token Launchpad</h1>
        <input id="name" className='inputText' type='text' placeholder='Name'></input> <br />
        <input id="symbol" className='inputText' type='text' placeholder='Symbol'></input> <br />
        <input id="image" className='inputText' type='text' placeholder='Image URL'></input> <br />
        <input id="supply" className='inputText' type='text' placeholder='Initial Supply'></input> <br />
        <button onClick={createtoken} className='btn'>Create a token</button>
    </div>
}