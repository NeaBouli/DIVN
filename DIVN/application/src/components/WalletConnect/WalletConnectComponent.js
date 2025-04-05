// WalletConnectComponent.js - React component for wallet connection and verification

const { useState, useEffect } = require('react');
const { connectWallet, handleVerifyLevel1, getCurrentLevel } = require('./WalletConnect');

function WalletConnectComponent() {
    const [account, setAccount] = useState(null);
    const [level, setLevel] = useState(null);
    const [verifyAddress, setVerifyAddress] = useState('');
    const [message, setMessage] = useState('');

    // Connect wallet on mount
    useEffect(() => {
        async function initialize() {
            try {
                const connectedAccount = await connectWallet();
                setAccount(connectedAccount);
                const userLevel = await getCurrentLevel();
                setLevel(userLevel);
            } catch (error) {
                setMessage('Failed to connect wallet: ' + error.message);
            }
        }
        initialize();
    }, []);

    // Handle verification submission
    const handleSubmit = async () => {
        try {
            setMessage('Verifying...');
            await handleVerifyLevel1(verifyAddress);
            setMessage('Verification successful!');
            const updatedLevel = await getCurrentLevel();
            setLevel(updatedLevel);
        } catch (error) {
            setMessage('Verification failed: ' + error.message);
        }
    };

    return (
        <div>
            <h2>DIVN Wallet Connection</h2>
            {account ? (
                <div>
                    <p>Connected Account: {account}</p>
                    <p>Verification Level: {level !== null ? level : 'Loading...'}</p>
                    <input
                        type="text"
                        value={verifyAddress}
                        onChange={(e) => setVerifyAddress(e.target.value)}
                        placeholder="Address to verify"
                    />
                    <button onClick={handleSubmit}>Verify Level 1</button>
                    <p>{message}</p>
                </div>
            ) : (
                <p>Connecting to wallet...</p>
            )}
        </div>
    );
}

module.exports = WalletConnectComponent;
