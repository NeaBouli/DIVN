# Installation and Setup for DIVN

This document provides detailed instructions to install and set up the DIVN project.

## Prerequisites
- **Node.js**: v18 or higher
- **Docker**: For node containerization
- **Hardhat**: For smart contract development
- **Polygon Wallet**: E.g., MetaMask with Mumbai Testnet or Mainnet

## Steps
1. **Clone the repository**:
   ```bash
   git clone https://github.com/NeaBouli/DIVN.git
   cd DIVN

Install dependencies:
For application/ and backend/:
bash

cd application && npm install
cd ../backend && npm install

For contracts/:
bash

cd contracts && npm install

Compile smart contracts:
bash

cd contracts && npx hardhat compile

Start nodes:
Validator Node:
bash

cd nodes/validator && docker build -t divn-validator . && docker run -d divn-validator

IPFS Node:
bash

cd nodes/ipfs && docker build -t divn-ipfs . && docker run -d divn-ipfs

Run the application:
bash

cd application && npm start

