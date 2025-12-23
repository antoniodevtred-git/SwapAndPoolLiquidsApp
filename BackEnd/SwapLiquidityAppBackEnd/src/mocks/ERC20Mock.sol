// test/mocks/ERC20Mock.sol
// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "../../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";


contract ERC20Mock is ERC20 {
    constructor(string memory name_, string memory symbol_, uint8 decimals_) ERC20(name_, symbol_) {
        _mint(msg.sender, 0); // mint to make constructor happy
    }

    function mint(address to_, uint amount_) external {
        _mint(to_, amount_);
    }

    function decimals() public view override returns (uint8) {
        return 18;
    }
    
}
