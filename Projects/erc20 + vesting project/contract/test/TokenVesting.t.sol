// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/TokenVesting.sol";

contract TokenVestingTest is Test {
    MyToken token;
    TokenVesting vesting;

    address owner = address(this);
    address alice = address(0x1);

    uint256 constant TOTAL = 1000 ether;
    uint256 constant CLIFF = 30 days;
    uint256 constant DURATION = 180 days;

    function setUp() public {
    
        token = new MyToken(1_000_000 ether);


        vesting = new TokenVesting(address(token));

    
        token.transfer(address(vesting), 10_000 ether);

    
        vesting.addBeneficiary(
            alice,
            TOTAL,
            CLIFF,
            DURATION
        );
    }

    function test_NoTokensBeforeCliff() public {
        vm.warp(block.timestamp + 10 days);

        vm.prank(alice);
        vm.expectRevert("Nothing to release");
        vesting.release();
    }

    function test_PartialVestingAfterCliff() public {
        vm.warp(block.timestamp + 60 days);

        uint256 vested = vesting.vestedAmount(alice);
        assertGt(vested, 0);

        vm.prank(alice);
        vesting.release();

        uint256 balance = token.balanceOf(alice);
        assertEq(balance, vested);
    }

  
    function test_FullVestingAfterDuration() public {
        vm.warp(block.timestamp + 200 days);

        vm.prank(alice);
        vesting.release();

        uint256 balance = token.balanceOf(alice);
        assertEq(balance, TOTAL);
    }

  
    function test_CannotClaimTwice() public {
        vm.warp(block.timestamp + 200 days);

        vm.prank(alice);
        vesting.release();

        vm.prank(alice);
        vm.expectRevert("Nothing to release");
        vesting.release();
    }

 
    function test_RevokeVesting() public {
        vm.warp(block.timestamp + 60 days);

        uint256 vestedBefore = vesting.vestedAmount(alice);

        vesting.revoke(alice);

        uint256 aliceBalance = token.balanceOf(alice);
        assertEq(aliceBalance, vestedBefore);
    }

  
    function test_NoReleaseAfterRevoke() public {
        vm.warp(block.timestamp + 60 days);

        vesting.revoke(alice);

        vm.prank(alice);
        vm.expectRevert("Vesting revoked");
        vesting.release();
    }
}
