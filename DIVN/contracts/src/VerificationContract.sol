// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract VerificationContract {
    // Mapping to store verification levels (0 = unverified, 1 = Level 1, 2 = Level 2, 3 = Level 3)
    mapping(address => uint8) public verificationLevel;
    // Mapping to track how many verifications a user has received for Level 1
    mapping(address => uint256) public verificationCount;
    // Mapping to prevent double verification for Level 1
    mapping(address => mapping(address => bool)) public hasVerified;
    // Address of the OpenID oracle for Level 2
    address public openIdOracle;
    // Address of the governmental oracle for Level 3
    address public govOracle;

    // Minimum verifications required for Level 1
    uint256 public constant MIN_VERIFICATIONS = 5;

    // Events
    event Verified(address indexed user, address indexed verifier, uint8 level);
    event OracleSet(address indexed oracle, string role);

    // Constructor to set oracle addresses
    constructor(address _openIdOracle, address _govOracle) {
        openIdOracle = _openIdOracle;
        govOracle = _govOracle;
        emit OracleSet(_openIdOracle, "OpenID");
        emit OracleSet(_govOracle, "Government");
    }

    // Modifier to restrict functions to oracles
    modifier onlyOracle(string memory _role) {
        if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("OpenID"))) {
            require(msg.sender == openIdOracle, "Only OpenID oracle can call this");
        } else if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Government"))) {
            require(msg.sender == govOracle, "Only Government oracle can call this");
        }
        _;
    }

    /**
     * Allows a verified user to verify another user for Level 1
     * @param _user The address to verify
     */
    function verifyLevel1(address _user) external {
        require(_user != msg.sender, "Cannot verify yourself");
        require(verificationLevel[msg.sender] >= 1, "Verifier must be at least Level 1");
        require(!hasVerified[msg.sender][_user], "Already verified this user");

        hasVerified[msg.sender][_user] = true;
        verificationCount[_user]++;

        if (verificationCount[_user] >= MIN_VERIFICATIONS && verificationLevel[_user] == 0) {
            verificationLevel[_user] = 1;
            emit Verified(_user, msg.sender, 1);
        }
    }

    /**
     * Called by the OpenID oracle to set Level 2 verification
     * @param _user The address to verify
     */
    function verifyLevel2(address _user) external onlyOracle("OpenID") {
        require(verificationLevel[_user] < 2, "User already at Level 2 or higher");
        verificationLevel[_user] = 2;
        emit Verified(_user, msg.sender, 2);
    }

    /**
     * Called by the governmental oracle to set Level 3 verification
     * @param _user The address to verify
     */
    function verifyLevel3(address _user) external onlyOracle("Government") {
        require(verificationLevel[_user] < 3, "User already at Level 3");
        verificationLevel[_user] = 3;
        emit Verified(_user, msg.sender, 3);
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
