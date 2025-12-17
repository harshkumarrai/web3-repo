# MyToken Deployment Guide

## Prerequisites
- Your Sepolia testnet private key
- Initial supply for your token (in wei)

## Environment Variables
You need to set two environment variables:

```bash
export PRIVATE_KEY="your_sepolia_private_key_here"
export INITIAL_SUPPLY="1000000000000000000000"  # 1000 tokens with 18 decimals
```

## Deployment Command
Run this command to deploy your MyToken contract:

```bash
forge script script/DeployVesting.s.sol --rpc-url sepolia --broadcast --verify
```

## What the script does:
1. Deploys the MyToken contract with your specified initial supply
2. Logs the contract address to the console
3. Verifies the contract on Etherscan (if you have an API key configured)

## Example:
```bash
# Set environment variables
export PRIVATE_KEY="0x1234567890abcdef..."
export INITIAL_SUPPLY="1000000000000000000000000"  # 1,000,000 tokens

# Deploy
forge script script/DeployVesting.s.sol --rpc-url sepolia --broadcast --verify
```

## After Deployment:
- The contract address will be displayed in the console
- You can verify the deployment on [Sepolia Etherscan](https://sepolia.etherscan.io/)
- Use the contract address to interact with your token

## Troubleshooting:
- Make sure your private key has Sepolia testnet ETH for gas fees
- Ensure the initial supply is in wei (not tokens)
- Check that your foundry.toml has the correct RPC endpoint

