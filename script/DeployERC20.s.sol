//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {MyERC20Token} from '../src/MyERC20Token.sol';
import {Script} from 'forge-std/Script.sol';

contract DeployERC20 is Script {

    // uint256 public constant INITIAL_SUPPLY = 10000 ether;
    uint256 public constant INITIAL_SUPPLY = 10000 * 1e18; 
    uint256 public constant DEFAULT_ANVIL_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    uint256 public deployerKey; 
    string public name = 'ShenZhenUniversityToken';
    string public symbol = 'SZU';

    function run() external returns(MyERC20Token){
        if (block.chainid == 31337) {
            deployerKey = DEFAULT_ANVIL_KEY;
        }
        vm.startBroadcast(deployerKey);
        MyERC20Token SZU = new MyERC20Token(name, symbol, INITIAL_SUPPLY);
        vm.stopBroadcast();
        return SZU;
    }
}