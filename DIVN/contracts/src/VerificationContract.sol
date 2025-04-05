// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IDIVToken {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract VerificationContract {
    IDIVToken public divToken;
    mapping(address => uint8) public verificationLevel;
    mapping(address => uint256) public verificationCount;
    mapping(address => mapping(address => bool)) public hasVerified;
    address public openIdOracle;
    address public govOracle;
    mapping(address => uint256) public stakedAmount;
    // Reputation system
    mapping(address => uint256) public reputationScore;
    uint256 public constant REWARD_PER_VERIFICATION = 0.1 * 10**18; // 0.1 DIV per verification

    uint256 public constant MIN_VERIFICATIONS = 5;
    uint256 public constant STAKE_AMOUNT = 1 * 10**18;
    uint256 public constant PRIORITY_FEE = 1 * 10**18;

    event Verified(address indexed user, address indexed verifier, uint8 level);
    event OracleSet(address indexed oracle, string role);
    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event ReputationEarned(address indexed verifier, uint256 amount);

    constructor(address _openIdOracle, address _govOracle, address _divToken) {
        openIdOracle = _openIdOracle;
        govOracle = _govOracle;
        divToken = IDIVToken(_divToken);
        emit OracleSet(_openIdOracle, "OpenID");
        emit OracleSet(_govOracle, "Government");
    }

    modifier onlyOracle(string memory _role) {
        if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("OpenID"))) {
            require(msg.sender == openIdOracle, "Only OpenID oracle can call this");
        } else if (keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("Government"))) {
            require(msg.sender == govOracle, "Only Government oracle can call this");
        }
        _;
    }

    function verifyLevel1(address _user) external {
        require(_user != msg.sender, "Cannot verify yourself");
        require(verificationLevel[msg.sender] >= 1, "Verifier must be at least Level 1");
        require(!hasVerified[msg.sender][_user], "Already verified this user");

        hasVerified[msg.sender][_user] = true;
        verificationCount[_user]++;

        if (verificationCount[_user] >= MIN_VERIFICATIONS && verificationLevel[_user] == 0) {
            verificationLevel[_user] = 1;
            emit Verified(_user, msg.sender, 1);
            _rewardVerifier(msg.sender);
        }
    }

    function verifyLevel1WithStake(address _user) external {
        require(_user != msg.sender, "Cannot verify yourself");
        require(verificationLevel[msg.sender] >= 1, "Verifier must be at least Level 1");
        require(!hasVerified[msg.sender][_user], "Already verified this user");
        require(stakedAmount[msg.sender] >= STAKE_AMOUNT, "Must stake 1 DIV token");

        hasVerified[msg.sender][_user] = true;
        verificationCount[_user]++;

        if (verificationCount[_user] >= MIN_VERIFICATIONS && verificationLevel[_user] == 0) {
            verificationLevel[_user] = 1;
            emit Verified(_user, msg.sender, 1);
            _rewardVerifier(msg.sender);
        }
    }

    function stake() external {
        require(divToken.transferFrom(msg.sender, address(this), STAKE_AMOUNT), "Stake transfer failed");
        stakedAmount[msg.sender] += STAKE_AMOUNT;
        emit Staked(msg.sender, STAKE_AMOUNT);
    }

    function unstake() external {
        require(stakedAmount[msg.sender] >= STAKE_AMOUNT, "No staked amount");
        stakedAmount[msg.sender] -= STAKE_AMOUNT;
        require(divToken.transfer(msg.sender, STAKE_AMOUNT), "Unstake transfer failed");
        emit Unstaked(msg.sender, STAKE_AMOUNT);
    }

    function verifyLevel2(address _user) external onlyOracle("OpenID") {
        require(verificationLevel[_user] < 2, "User already at Level 2 or higher");
        verificationLevel[_user] = 2;
        emit Verified(_user, msg.sender, 2);
    }

    function verifyLevel2WithPriority(address _user) external onlyOracle("OpenID") {
        require(divToken.transferFrom(_user, address(this), PRIORITY_FEE), "Priority fee failed");
        require(verificationLevel[_user] < 2, "User already at Level 2 or higher");
        verificationLevel[_user] = 2;
        emit Verified(_user, msg.sender, 2);
    }

    function verifyLevel3(address _user) external onlyOracle("Government") {
        require(verificationLevel[_user] < 3, "User already at Level 3");
        verificationLevel[_user] = 3;
        emit Verified(_user, msg.sender, 3);
    }

    function getVerificationLevel(address _user) external view returns (uint8) {
        return verificationLevel[_user];
    }

    // Internal function to reward verifiers
    function _rewardVerifier(address _verifier) internal {
        reputationScore[_verifier] += 10; // 10 reputation points per successful verification
        require(divToken.transfer(_verifier, REWARD_PER_VERIFICATION), "Reward transfer failed");
        emit ReputationEarned(_verifier, REWARD_PER_VERIFICATION);
    }
}
