// Home.js - Main page component for DIVN UI

const { connectWallet, getCurrentLevel, handleVerifyLevel1 } = require('../../components/WalletConnect/WalletConnect');

class Home {
    constructor() {
        this.account = null;
        this.level = 0;
    }

    // Connect to wallet and update UI
    async connect() {
        try {
            this.account = await connectWallet();
            this.level = await getCurrentLevel();
            this.updateUI();
        } catch (error) {
            console.error("Connection failed:", error);
            document.getElementById('status').innerText = "Connection failed: " + error.message;
        }
    }

    // Verify another user (example address for now)
    async verify() {
        if (!this.account) {
            document.getElementById('status').innerText = "Please connect wallet first";
            return;
        }
        try {
            // Example address - replace with user input in real app
            const userToVerify = "0x1234567890123456789012345678901234567890";
            await handleVerifyLevel1(userToVerify);
            document.getElementById('status').innerText = `Verified ${userToVerify} successfully!`;
        } catch (error) {
            console.error("Verification failed:", error);
            document.getElementById('status').innerText = "Verification failed: " + error.message;
        }
    }

    // Update UI with current status
    updateUI() {
        document.getElementById('account').innerText = this.account || "Not connected";
        document.getElementById('level').innerText = this.level;
        document.getElementById('status').innerText = "Connected successfully";
    }

    // Render method (simplified for now - integrate with React framework later)
    render() {
        return `
            <div>
                <h1>DIVN - Decentralized Identity Verification</h1>
                <p>Account: <span id="account">Not connected</span></p>
                <p>Verification Level: <span id="level">0</span></p>
                <button onclick="home.connect()">Connect Wallet</button>
                <button onclick="home.verify()">Verify User (Level 1)</button>
                <p>Status: <span id="status">Disconnected</span></p>
            </div>
        `;
    }
}

// Singleton instance for simplicity
const home = new Home();

// Export for use in app
module.exports = home;
