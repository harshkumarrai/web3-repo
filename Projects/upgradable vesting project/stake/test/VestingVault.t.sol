// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/VestingVault.sol";
import "../src/VestingVaultV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockToken is ERC20 {
    constructor() ERC20("Mock", "MOCK") {
        _mint(msg.sender, 1_000_000 ether);
    }
}

contract VestingVaultTest is Test {
    address owner = address(1);
    address alice = address(2);

    MockToken token;
    VestingVault vault;

    function setUp() public {
        vm.startPrank(owner);
        token = new MockToken();

        VestingVault impl = new VestingVault();

        bytes memory data = abi.encodeWithSelector(
            VestingVault.initialize.selector,
            address(token),
            owner
        );

        ERC1967Proxy proxy = new ERC1967Proxy(
            address(impl),
            data
        );

        vault = VestingVault(address(proxy));

        token.approve(address(vault), 1000 ether);
        vm.stopPrank();
    }

    function testCreateVesting() public {
        vm.prank(owner);
        vault.createVesting(
            alice,
            100 ether,
            uint64(block.timestamp),
            10 days,
            100 days
        );

        assertEq(token.balanceOf(address(vault)), 100 ether);
    }

    function testReleaseAfterCliff() public {
        vm.prank(owner);
        vault.createVesting(
            alice,
            100 ether,
            uint64(block.timestamp),
            10 days,
            100 days
        );

        vm.warp(block.timestamp + 20 days);

        vm.prank(alice);
        vault.release();

        assertGt(token.balanceOf(alice), 0);
    }

    function testUpgradePreservesState() public {
        vm.prank(owner);
        vault.createVesting(
            alice,
            100 ether,
            uint64(block.timestamp),
            10 days,
            100 days
        );

        VestingVaultV2 v2 = new VestingVaultV2();

        vm.prank(owner);
        vault.upgradeToAndCall(address(v2),"");

        (uint256 total,,,,,) = vault.vestings(alice);
        assertEq(total, 100 ether);
    }
}
