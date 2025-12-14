// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/StakingContract.sol";
contract StakingContract is Test{
    StakeContract c;

    function setUp()public {
        c=new StakeContract();
    }
    function testc1()public {
        c.stake{value :200}(200);
        assert(c.balanceof()==200);

    }
}