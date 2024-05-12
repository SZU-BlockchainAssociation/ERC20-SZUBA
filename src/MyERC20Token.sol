//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {ERC20} from './ERC20.sol';

contract MyERC20Token is ERC20{

    constructor(string memory name, string memory symbol, uint256 initialSupply)
        ERC20(name, symbol)
    {
        //给合约部署者mint 100个代币
        _mint(msg.sender, initialSupply);
    }

}