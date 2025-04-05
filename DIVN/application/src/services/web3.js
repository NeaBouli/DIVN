// web3.js - Handles blockchain interactions via Web3.js

const Web3 = require('web3');
// TODO: Configure Web3 provider (e.g., Polygon Mumbai Testnet)
const web3 = new Web3('https://rpc-mumbai.matic.today');

/**
 * Connects to the VerificationContract on Polygon
 * @param {string} contractAddress - The deployed contract address
 * @returns {Object} - The contract instance
 */
function getVerificationContract(contractAddress) {
    const abi = []; // TODO: Add ABI from VerificationContract.sol
    // TODO: Initialize contract instance
    return new web3.eth.Contract(abi, contractAddress);
}

module.exports = { getVerificationContract };
