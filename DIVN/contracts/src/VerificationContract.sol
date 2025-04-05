// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract VerificationContract {
    // Mapping to store verification levels (0 = unverified, 1 = Level 1, etc.)
    mapping(address => uint8) public verificationLevel;
    // Mapping to track how many verifications a user has received
    mapping(address => uint256) public verificationCount;
    // Mapping to prevent double verification
    mapping(address => mapping(address => bool)) public hasVerified;

    // Minimum verifications required for Level 1
    uint256 public constant MIN_VERIFICATIONS = 5;

    // Event emitted when a user is verified
    event Verified(address indexed user, address indexed verifier, uint8 level);

    /**
     * Allows a verified user to verify another user for Level 1
     * @param _user The address to verify
     */
    function verifyLevel1(address _user) external {
        require(_user != msg.sender, "Cannot verify yourself");
        require(verificationLevel[msg.sender] >= 1, "Verifier must be at least Level 1");
        require(!hasVerified[msg.sender][_user], "Already verified this user");

        // Mark as verified by this sender
        hasVerified[msg.sender][_user] = true;
        verificationCount[_user]++;

        // Check if minimum verifications reached
        if (verificationCount[_user] >= MIN_VERIFICATIONS && verificationLevel[_user] == 0) {
            verificationLevel[_user] = 1;
            emit Verified(_user, msg.sender, 1);
        }
    }

    /**
     * Returns the verification level of a user
     * @param _user The address to check
     * @return uint8 The verification level
     */
    function getVerificationLevel(address _user) external view returns (uint8) {
        return verificationLevel[_user];
    }
}
