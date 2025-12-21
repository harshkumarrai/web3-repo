// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VestingVault.sol";

contract VestingVaultV2 is VestingVault {
    event EmergencyWithdraw(uint256 amount);

    function emergencyWithdraw(uint256 amount) external onlyOwner {
        token.transfer(owner(), amount);
        emit EmergencyWithdraw(amount);
    }

    function version() external pure returns (uint256) {
        return 2;
    }
}
