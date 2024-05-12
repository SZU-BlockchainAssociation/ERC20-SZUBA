//SPDX-License-Identifier:MIT
pragma solidity ^0.8.24;

import {Test,console} from 'forge-std/Test.sol';
import {MyERC20Token} from '../src/MyERC20Token.sol';
import {DeployERC20} from '../script/DeployERC20.s.sol';
import {IERC20Errors} from '../src/Interfaces/IERC6093.sol';

contract TestERC20Token is Test {
    
    MyERC20Token public SZU;
    DeployERC20 public deployer;
    address public bob;
    address public alice;
    uint256 public constant INITIAL_BALANCE = 10 ether;
    
    function setUp() external {
        deployer = new DeployERC20();
        SZU = deployer.run();
        
        bob = makeAddr('bob');
        alice = makeAddr('alice');

        address deployerAddess = vm.addr(deployer.deployerKey());
        vm.prank(deployerAddess);
        SZU.transfer(bob, 10 ether);
    }

    function testTotalSupply() public view{
        assertEq(SZU.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    function testName() public view{
        assertEq(SZU.name(), 'ShenZhenUniversityToken');
    }
    
    function testSymbol() public view{
        assertEq(SZU.symbol(), 'SZU');
    }

    function testDecimals() public view{
        assertEq(SZU.decimals(), 18);
    }

    function testBalanceOf() public{
        vm.prank(bob);
        assertEq(SZU.balanceOf(bob), 10 ether);
    }

    function testTransfer() public{
        vm.prank(bob);
        SZU.transfer(alice, 3 ether);
        assertEq(SZU.balanceOf(alice), 3 ether);
    }

    function testAllowance() public{
        uint256 allowance = 2 ether;
        uint256 transferAmount = 0.5 ether;

        vm.prank(bob);
        SZU.approve(alice, allowance);
        assertEq(SZU.allowance(bob, alice), allowance);

        vm.prank(alice);
        SZU.transferFrom(bob, alice, transferAmount);
        assertEq(SZU.balanceOf(alice), transferAmount);
        assertEq(SZU.allowance(bob, alice), allowance - transferAmount);
    }

    function testApprove() public{
        uint256 allowance = 1.5 ether;
        vm.prank(bob);
        SZU.approve(alice, allowance);
        assertEq(SZU.allowance(bob, alice), allowance);
    }

    function testRevertIfFromEqualsToZeroAddress() public {
        uint256 transferAmount = 1 ether;

        vm.prank(address(0));
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidSender.selector, address(0)));
        SZU.transfer(alice, transferAmount);
    }

    function testRevertIfToEqualsZeroAddress() public {
        uint256 transferAmount = 1 ether;

        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0)));
        SZU.transfer(address(0), transferAmount);
    }

    function testRevertIfOwnerOfApproveIsZeroAddress() public {
        vm.prank(address(0));
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidApprover.selector, address(0)));
        SZU.approve(address(0), 1 ether);
    }

    function testRevertIfSpenderOfApproveIsZeroAddress() public {
        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidSpender.selector, address(0)));
        SZU.approve(address(0), 1 ether);
    }

    function testMintSzuIfFromIsZeroAddress() public {
        uint256 mintAmount = 1 ether;
        
        vm.prank(alice);
        SZU._update(address(0), alice, mintAmount);
        assertEq(SZU.balanceOf(alice), mintAmount);
        assertEq(SZU.totalSupply(), deployer.INITIAL_SUPPLY() + mintAmount);
    }

    function testBurnSzuIfToIsZeroAddress() public {
        uint256 burnAmount = 1 ether;
        
        vm.prank(bob);
        SZU._update(bob, address(0), burnAmount);
        assertEq(SZU.balanceOf(bob), INITIAL_BALANCE - burnAmount);
        assertEq(SZU.totalSupply(), deployer.INITIAL_SUPPLY() - burnAmount);
    }

    function testTransferFromRevertIfInsufficientAllowance() public {
        uint256 allowance = 1 ether;
        uint256 transferAmount = 2 ether;

        vm.prank(bob);
        SZU.approve(alice, allowance);
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientAllowance.selector, alice, allowance, transferAmount));
        SZU.transferFrom(bob, alice, transferAmount);
    }

    function testRevertInseffecientBalance() public {
        uint256 transferAmount = 1 ether;
        uint256 aliceBalance = 0;

        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, alice, aliceBalance, transferAmount));
        SZU.transfer(bob, transferAmount);
    }

    function testRevertIfMintToZeroAddress() public{
        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0)));
        SZU._mint(address(0), 1 ether);
    }

    function testRevertIfBurnFromZeroAddress() public{
        vm.prank(bob);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidSender.selector, address(0)));
        SZU._burn(address(0), 1 ether);
    }

    function testMintSuccessIfToIsNotZeroAddress() public{
        uint256 mintAmount = 1 ether;
        vm.prank(alice);
        SZU._mint(alice, mintAmount);
        assertEq(SZU.balanceOf(alice), mintAmount);
        assertEq(SZU.totalSupply(), deployer.INITIAL_SUPPLY() + mintAmount);
    }

    function testBurnSuccessIfFromIsNotZeroAddress() public{
        uint256 burnAmount = 1 ether;
        vm.prank(bob);
        SZU._burn(bob, burnAmount);
        assertEq(SZU.balanceOf(bob), INITIAL_BALANCE - burnAmount);
        assertEq(SZU.totalSupply(), deployer.INITIAL_SUPPLY() - burnAmount);
    }
}