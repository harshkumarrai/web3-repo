// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/CrowdFund.sol";

contract CrowdFundTest is Test {
    CrowdFund fund;

    address creator = address(1);
    address user1 = address(2);

    function setUp() public {
        fund = new CrowdFund();

        vm.deal(creator, 10 ether);
        vm.deal(user1, 10 ether);
    }

    function testCreateCampaign() public {
        vm.prank(creator);
        fund.createCampaign(5 ether, 7 days);

        (address cCreator, uint goal,,,) = fund.campaigns(1);
        assertEq(cCreator, creator);
        assertEq(goal, 5 ether);
    }

    function testContribution() public {
        vm.prank(creator);
        fund.createCampaign(5 ether, 7 days);

        vm.prank(user1);
        fund.contribute{value: 1 ether}(1);

        (, , , uint raised,) = fund.campaigns(1);
        assertEq(raised, 1 ether);
    }

    function testWithdrawSuccess() public {
        vm.prank(creator);
        fund.createCampaign(1 ether, 1 days);

        vm.prank(user1);
        fund.contribute{value: 1 ether}(1);

        vm.warp(block.timestamp + 2 days);

        vm.prank(creator);
        fund.withdraw(1);

        assertEq(creator.balance, 11 ether);
    }

    function testRefund() public {
        vm.prank(creator);
        fund.createCampaign(5 ether, 1 days);

        vm.prank(user1);
        fund.contribute{value: 1 ether}(1);

        vm.warp(block.timestamp + 2 days);

        vm.prank(user1);
        fund.refund(1);

        assertEq(user1.balance, 10 ether);
    }
}
