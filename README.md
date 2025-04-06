# DIVN - Decentralized System for Identity Verification
A decentralized system for identity verification on the Polygon 
blockchain, combining community, OpenID, and governmental validation. DIVN 
enables users to securely and anonymously verify their identity, keeping 
all personal data in their wallet while storing only cryptographic proofs 
on the blockchain.

## Concept Overview
DIVN is designed to provide a secure, scalable, and privacy-focused 
identity verification system. Here’s how it works:

- **Multi-Tiered Verification:**
  - *Level 1:* Community-based verification by other users, leveraging 
trust within the network.
  - *Level 2:* Integration with OpenID providers (e.g., Google, Microsoft) 
for a standardized identity check.
  - *Level 3:* Governmental validation (e.g., BundID) for official 
identity confirmation.
- **Modes of Operation:**
  - *Basic Mode:* Free verification, slower processing.
  - *Stake Mode:* Requires a 1-token deposit for increased trust and 
speed.
  - *Priority Mode:* 1-token fee for expedited verification.
- **Technical Foundation:**
  - *Polygon PoS Chain:* Ensures scalability with 65,000 TPS and low costs 
($0.001 per transaction).
  - *Smart Contracts:* Automate verification logic and token management.
  - *IPFS:* Temporarily stores encrypted data with a 24-hour TTL.
  - *Node Network:* Includes Validator, Full, Light, and IPFS nodes for 
decentralization.

The system ensures that no sensitive personal data is stored on-chain—only 
cryptographic proofs (e.g., zero-knowledge proofs) are recorded, while 
users retain full control over their data via their wallets.

## Directory Structure
The repository is modularly structured for ease of development and 
maintenance. Below is the structure:

```plaintext
DIVN/
├── application/ - Main application (wallet and user interface)
│   ├── src/ - Source code of the application
│   │   ├── components/ - Reusable UI components
│   │   │   ├── WalletConnect/ - Wallet connection (e.g., MetaMask)
│   │   │   ├── VerificationForm/ - Forms for verification requests
│   │   │   └── StatusDisplay/ - Display of verification status
│   │   ├── pages/ - Application pages
│   │   │   ├── Home/ - Homepage
│   │   │   ├── VerifyLevel1/ - Page for Level 1 verification
│   │   │   ├── VerifyLevel2/ - Page for Level 2 verification
│   │   │   └── VerifyLevel3/ - Page for Level 3 verification
│   │   ├── services/ - API and blockchain interactions
│   │   │   ├── ipfs.js - IPFS upload and access
│   │   │   ├── web3.js - Blockchain connection (Web3.js)
│   │   │   └── auth.js - Authentication (OpenID, eID)
│   │   ├── utils/ - Utility functions
│   │   │   ├── encryption.js - AES-256 encryption
│   │   │   └── signature.js - Signatures for proofs
│   │   └── config/ - Configuration files
│   │       ├── constants.js - Constant values (e.g., MIN_STAKE)
│   │       └── network.js - Network configuration (Polygon)
│   ├── public/ - Static files (e.g., images, HTML)
│   ├── tests/ - Unit tests for the application
│   └── package.json - Dependencies and scripts
├── frontend/ - Frontend-specific files (optional separation)
│   ├── src/ - Frontend source code
│   │   ├── assets/ - Static assets (CSS, images)
│   │   ├── components/ - As in application/src/components
│   │   ├── pages/ - As in application/src/pages
│   │   └── redux/ - State management (optional)
│   ├── build/ - Compiled frontend files
│   └── webpack.config.js - Build configuration
├── backend/ - Backend server (API and oracle integration)
│   ├── src/ - Backend source code
│   │   ├── api/ - API endpoints
│   │   │   ├── verify.js - Query verification status
│   │   │   └── user.js - Anonymous user data management
│   │   ├── services/ - Backend services
│   │   │   ├── chainlink.js - Chainlink oracle integration
│   │   │   └── ipfs.js - IPFS interaction from backend
│   │   ├── middleware/ - Authentication and logging
│   │   └── config/ - Configuration
│   │       ├── db.js - Database (if needed, e.g., logs)
│   │       └── env.js - Environment variables
│   ├── tests/ - Unit tests for the backend
│   └── server.js - Main server file (e.g., Express.js)
├── nodes/ - Node-specific configurations and scripts
│   ├── validator/ - Validator nodes
│   │   ├── config/ - Validator node configuration
│   │   │   ├── bor.json - Bor configuration (Polygon)
│   │   │   └── heimdall.json - Heimdall configuration
│   │   ├── scripts/ - Start and management scripts
│   │   │   ├── start.sh - Start script for validator
│   │   │   └── sync.sh - Sync with mainnet
│   │   └── docker/ - Docker files
│   │       └── Dockerfile - Docker image for validator
│   ├── full/ - Full nodes
│   │   ├── config/ - Full node configuration
│   │   ├── scripts/ - Start and sync scripts
│   │   └── docker/ - Docker image for full node
│   ├── light/ - Light nodes
│   │   ├── config/ - Light node configuration
│   │   ├── scripts/ - Start scripts
│   │   └── docker/ - Docker image for light node
│   └── ipfs/ - IPFS nodes
│       ├── config/ - IPFS configuration
│       │   └── ipfs-config.json - TTL and API settings
│       ├── scripts/ - IPFS start and cleanup
│       │   ├── start.sh - Starts IPFS daemon
│       │   └── cleanup.sh - Deletes data after 24h
│       └── docker/ - Docker image for IPFS
│       └── README.md - Node setup instructions
├── contracts/ - Smart contracts
│   ├── src/ - Smart contract source code
│   │   ├── VerificationContract.sol - Verification logic
│   │   ├── TokenContract.sol - DIV token (ERC-20)
│   │   └── ReputationContract.sol - Reputation management
│   ├── scripts/ - Deployment and test scripts
│   │   ├── deploy.js - Deployment to Polygon
│   │   └── test.js - Test scripts
│   ├── test/ - Unit tests for smart contracts
│   └── hardhat.config.js - Hardhat configuration
├── docs/ - Documentation
│   ├── whitepaper/ - White Paper
│   │   └── DIVN-Whitepaper.md - Detailed White Paper in Markdown
│   ├── api/ - API documentation
│   │   └── api-spec.md - Backend API specification
│   ├── architecture/ - Architecture overview
│   │   └── overview.md - Technical architecture
│   └── README.md - Documentation overview
├── tests/ - System-wide integration tests
│   ├── e2e/ - End-to-end tests
│   └── mocks/ - Mock data for tests
├── config/ - Global configurations
│   ├── docker-compose.yml - Docker Compose for all services
│   ├── .env.example - Example environment variables
│   └── networks.json - Network configurations (Polygon)
├── .github/ - GitHub-specific files
│   ├── workflows/ - CI/CD pipelines
│   │   ├── test.yml - Automated tests
│   │   └── deploy.yml - Deployment pipeline
│   └── PULL_REQUEST_TEMPLATE.md - Pull request template
├── .gitignore - Ignored files (e.g., node_modules)
└── LICENSE - License (e.g., MIT)
