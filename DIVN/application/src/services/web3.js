// web3.js - Handles blockchain interactions via Web3.js

const Web3 = require('web3');

// TODO: Replace with actual deployed contract address
const CONTRACT_ADDRESS = "0xYourContractAddressHere";
const ABI = [
    {
        "inputs": [{"internalType": "address", "name": "_user", "type": "address"}],
        "name": "verifyLevel1",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [{"internalType": "address", "name": "_user", "type": "address"}],
        "name": "getVerificationLevel",
        "outputs": [{"internalType": "uint8", "name": "", "type": "uint8"}],
        "stateMutability": "view",
        "type": "function"
    },
    // TODO: Add more ABI entries as contract evolves
];

// Initialize Web3 with Polygon Mumbai Testnet
const web3 = new Web3('https://rpc-mumbai.matic.today');

/**
 * Connects to the VerificationContract
 * @returns {Object} - The contract instance
 */
function getVerificationContract() {
    return new web3.eth.Contract(ABI, CONTRACT_ADDRESS);
}

/**
 * Verifies a user for Level 1
 * @param {string} account - The sender's Ethereum address
 * @param {string} userToVerify - The address to verify
 * @returns {Promise} - Transaction receipt
 */
async function verifyLevel1(account, userToVerify) {
    const contract = getVerificationContract();
    try {
        const tx = await contract.methods.verifyLevel1(userToVerify).send({ from: account });
        return tx;
    } catch (error) {
        console.error("Verification failed:", error);
        throw error;
    }
}

/**
 * Gets the verification level of a user
 * @param {string} user - The address to check
 * @returns {Promise<number>} - The verification level (0-3)
 */
async function getVerificationLevel(user) {
    const contract = getVerificationContract();
    try {
        const level = await contract.methods.getVerificationLevel(user).call();
        return parseInt(level);
    } catch (error) {
        console.error("Failed to get verification level:", error);
        throw error;
    }
}

module.exports = { getVerificationContract, verifyLevel1, getVerificationLevel };
