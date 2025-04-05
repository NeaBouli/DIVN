// WalletConnect.js - Connects to MetaMask and interacts with VerificationContract

const Web3 = require('web3');
const { getVerificationContract, verifyLevel1, getVerificationLevel } = require('../../services/web3');

// State for wallet connection
let web3 = null;
let accounts = [];

/**
 * Connects to MetaMask wallet
 * @returns {Promise<string>} - The connected account address
 */
async function connectWallet() {
    if (window.ethereum) {
        try {
            // Request account access
            await window.ethereum.request({ method: 'eth_requestAccounts' });
            web3 = new Web3(window.ethereum);
            accounts = await web3.eth.getAccounts();
            console.log("Connected account:", accounts[0]);
            return accounts[0];
        } catch (error) {
            console.error("Wallet connection failed:", error);
            throw error;
        }
    } else {
        throw new Error("MetaMask not detected. Please install MetaMask.");
    }
}

/**
 * Verifies a user via Level 1
 * @param {string} userToVerify - The address to verify
 * @returns {Promise} - Transaction receipt
 */
async function handleVerifyLevel1(userToVerify) {
    if (!accounts.length) {
        throw new Error("Wallet not connected. Please connect first.");
    }
    return await verifyLevel1(accounts[0], userToVerify);
}

/**
 * Gets the current verification level of the connected user
 * @returns {Promise<number>} - The verification level
 */
async function getCurrentLevel() {
    if (!accounts.length) {
        throw new Error("Wallet not connected. Please connect first.");
    }
    return await getVerificationLevel(accounts[0]);
}

// Example usage (can be called from UI)
async function init() {
    try {
        const account = await connectWallet();
        const level = await getCurrentLevel();
        console.log(`Account ${account} is at verification level ${level}`);
        // TODO: Call handleVerifyLevel1 when user submits a verification request
    } catch (error) {
        console.error("Initialization failed:", error);
    }
}

module.exports = { connectWallet, handleVerifyLevel1, getCurrentLevel, init };
