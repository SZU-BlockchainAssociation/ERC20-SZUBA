//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

interface IERC20 {
    
    event Transfer(address indexed from, address indexed to, uint256 indexed value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev 
     */
    function totalSupply() external view returns(uint256);

    function balanceOf(address owner) external view returns(uint256);

    function transfer(address to, uint256 value) external returns(bool);//返回转账成功情况

    function allowance(address owner, address spender) external view returns(uint256);

    function approve(address spender, uint256 value) external returns(bool);

    function transferFrom(address from, address to, uint256 value) external returns(bool);

}