// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import {Iccoin} from "../src/Iccoin.sol";

contract TestIccoin is Test {
    Iccoin c;
    event Transfer(address indexed from, address indexed to, uint256 value);
    uint256 DECIMALS = 10 ** 18;

    function setUp() public {
        c = new Iccoin(uint(100));
    }

    function testInitialBalance() public {
        assertEq(c.balanceOf(address(this)), 100 * DECIMALS, "ok");
    }

    function testMint() public {
        c.mint(address(this), 100 * DECIMALS);
        assertEq(c.balanceOf(address(this)), 200 * DECIMALS, "ok");
    }

    function testTransfer() public {
        address addr = address(this);
        c.mint(addr, 100 * DECIMALS);
        c.transfer(0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35, 50 * DECIMALS);
        assertEq(c.balanceOf(addr), 150 * DECIMALS, "ok");
        assertEq(c.balanceOf(0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35), 50 * DECIMALS, "ok");
    }

    function testApprovals() public {
        c.mint(address(this), 100 * DECIMALS);
        c.approve(0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35, 50 * DECIMALS);
        vm.prank(0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35);
        c.transferFrom(address(this), 0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35, 50 * DECIMALS);
        assertEq(c.balanceOf(address(this)), 150 * DECIMALS, "ok");
        assertEq(c.balanceOf(0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35), 50 * DECIMALS, "ok");
    }

    function testTransferEmit() public {
        console.log("Testing Transfer Emit");
        c.mint(address(this), 100 * DECIMALS);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(this), 0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35, 50 * DECIMALS);
        c.transfer(0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35, 50 * DECIMALS);
    }

    function test_Dealexample() public {
        address addr = 0xf0d013312CAc8Af5Aaa135c7c8bFd604B5915D35;
        deal(address(c), addr, 500 * DECIMALS);
        assertEq(c.balanceOf(addr), 500 * DECIMALS, "ok");
    }
}