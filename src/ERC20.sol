//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {IERC20} from './Interfaces/IERC20.sol';
import {IERC20Metadata} from './Interfaces/IERC20Metadata.sol';
import {IERC20Errors} from './Interfaces/IERC6093.sol';

contract ERC20 is IERC20, IERC20Metadata, IERC20Errors{

    mapping (address => uint256) private s_balance;
    mapping(address owner => mapping(address operator => uint256 value)) private s_allowance;
    uint256 private s_totalSupply;
    uint8 public constant s_decimals = 18;
    string private s_name;
    string private s_symbol;

    constructor(string memory name_, string memory symbol_){
        s_name = name_;
        s_symbol = symbol_;
    }

    function name() public view override returns(string memory){
        return s_name;
    }

    function symbol() public view override returns(string memory){
        return s_symbol;
    }

    function decimals() public pure override returns(uint8){
        return s_decimals;
    }

    function totalSupply() public view override returns(uint256){
        return s_totalSupply;
    }

    function balanceOf(address owner) public view override returns(uint256){
        return s_balance[owner];
    }

    function transfer(address to, uint256 value) public override returns(bool){
        address from = msg.sender;
        _transfer(from, to, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public override returns(bool){
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    function allowance(address owner, address spender) public view override returns(uint256){
        return s_allowance[owner][spender];
    }

    function approve(address spender, uint256 value) public override returns(bool){
        address owner = msg.sender;
        _approve(owner, spender, value);
        return true;
    }

//////////////////////////////////////////// internal functions  //////////////////////////////////////////////////////////////

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from` (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding this function.
     * 
     * @dev Chinese: 从`from`到`to`转移`value`数量的代币，或者如果`from`（或`to`）是零地址，则进行铸造（或销毁）。
     * 所有对转账、铸造和销毁的自定义应通过重写此函数来完成。
     */
    function _update(address from, address to, uint256 value) public virtual {
        if(from == address(0)){
            s_totalSupply += value;
        }
        else if(s_balance[from] < value){
            revert ERC20InsufficientBalance(from, s_balance[from], value);
        }
        unchecked {
            s_balance[from] -= value; //unchecked: 不检查溢出
        }
        if(to == address(0)){
            unchecked{ s_totalSupply -= value; }
        }else{
            s_balance[to] += value;
        }
        emit Transfer(from, to, value);
    }

    function _mint(address to, uint256 value) public {
        if(to == address(0)){
            revert ERC20InvalidReceiver(to);
        }
        _update(address(0), to, value);
    }

    function _burn(address from, uint256 value) public {
        if(from == address(0)){
            revert ERC20InvalidSender(from);
        }
        _update(from, address(0), value);
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal virtual{
        uint256 currentAllowance = allowance(owner, spender);
        if(currentAllowance != type(uint256).max){
            if(currentAllowance < value){
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked{
                _approve(owner, spender, currentAllowance - value, false); //通过重新设定approve的方式减少授权额度
            }
        }
    }

    /**
     * @dev 通过调整emitEvent参数，可以选择在调用此函数时选择是否触发事件。emit event will cost gas.
     */
    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual{
        if(owner == address(0)){
            revert ERC20InvalidApprover(owner);
        }
        if(spender == address(0)){
            revert ERC20InvalidSpender(spender);
        }
        s_allowance[owner][spender] = value;
        if(emitEvent){
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev 重载了`_approve`函数，使其默认触发事件。（emitEvent为true）
     */
    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    function _transfer(address from, address to, uint256 value) internal virtual{
        if(from == address(0)){
            revert ERC20InvalidSender(from);
        }else if(to == address(0)){
            revert ERC20InvalidReceiver(to);
        }else{
            _update(from, to, value);
        }
    }
}