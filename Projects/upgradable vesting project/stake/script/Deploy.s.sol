// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/VestingVault.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract Deploy is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        address token = vm.envAddress("TOKEN_ADDRESS");

        vm.startBroadcast(pk);

        VestingVault impl = new VestingVault();

        bytes memory data = abi.encodeWithSelector(
            VestingVault.initialize.selector,
            token,
            msg.sender
        );

        new ERC1967Proxy(address(impl), data);

        vm.stopBroadcast();
    }
}
