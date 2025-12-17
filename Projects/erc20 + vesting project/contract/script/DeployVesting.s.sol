// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/MyToken.sol";

contract DeployVestingScript is Script {
    function setUp() public {}



    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        uint256 initialSupply = 10000000000000000000000; 
        
        vm.startBroadcast(deployerPrivateKey);

        MyToken myToken = new MyToken(initialSupply);

        vm.stopBroadcast();

        console.log("MyToken deployed to:", address(myToken));
        console.log("Initial supply:", initialSupply);
    }
}
