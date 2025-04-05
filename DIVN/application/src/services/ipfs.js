// ipfs.js - Handles IPFS interactions for temporary data storage

const IPFS = require('ipfs-http-client');
// TODO: Initialize IPFS client with proper configuration
const ipfs = IPFS.create({ host: 'localhost', port: '5001', protocol: 'http' });

/**
 * Uploads encrypted data to IPFS with a 24-hour TTL
 * @param {Buffer} encryptedData - The encrypted data to upload
 * @returns {string} - The IPFS CID (Content Identifier)
 */
async function uploadToIPFS(encryptedData) {
    // TODO: Implement IPFS upload logic
    const { cid } = await ipfs.add(encryptedData, { pin: true });
    // TODO: Set TTL to 24 hours
    return cid.toString();
}

module.exports = { uploadToIPFS };
