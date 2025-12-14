// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/OrcaCoin.sol";

contract OrcaCoinTest is Test {
    OrcaCoinCointract c;
    function setUp() public {
        c=new OrcaCoinCointract(address(this));
    }

    function testsupply()  public view {
        assert(c.totalSupply()==0);
        
    }
    // function testFailtcc() public   {
    //     vm.startPrank(0x6b468b4ac85229FDE2aF0426BBEEbF084BEc3600);
    //     c.mint(0x6b468b4ac85229FDE2aF0426BBEEbF084BEc3600, 200);
    // }
    function testMint() public{
        c.mint(0x6b468b4ac85229FDE2aF0426BBEEbF084BEc3600, 10);
        assert(c.totalSupply()==10);
    }
    function test_Revert_changesstakecontract() public {
        // simulate a non-owner for a single call
        vm.prank(0x6b468b4ac85229FDE2aF0426BBEEbF084BEc3600);

        // generic revert expectation; if the contract is Ownable use the exact message:
        // vm.expectRevert("Ownable: caller is not the owner");
        vm.expectRevert();
        c.updatestakingcontract(0x6b468b4ac85229FDE2aF0426BBEEbF084BEc3600);
    }
   

}
