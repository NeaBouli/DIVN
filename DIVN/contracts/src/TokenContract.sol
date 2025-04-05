// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DIVToken is ERC20 {
    // Initial supply: 1 billion tokens (adjustable)
    uint256 constant INITIAL_SUPPLY = 1_000_000_000 * 10**18;

    constructor() ERC20("DIV Token", "DIV") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    // Optional: Add burn function for deflationary mechanics
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
}
