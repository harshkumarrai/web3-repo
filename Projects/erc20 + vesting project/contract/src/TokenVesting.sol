// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenVesting is Ownable(msg.sender) {
    IERC20 public immutable token;

    struct VestingSchedule {
        uint256 total;     
        uint256 released;   
        uint256 start;      
        uint256 cliff;      
        uint256 duration;   
        bool revoked;       
    }

    mapping(address => VestingSchedule) public vestings;

    event VestingAdded(address indexed beneficiary, uint256 total);
    event TokensReleased(address indexed beneficiary, uint256 amount);
    event VestingRevoked(address indexed beneficiary);

    constructor(address _token) {
        token = IERC20(_token);
    }
    
    function addBeneficiary(
        address beneficiary,
        uint256 totalAmount,
        uint256 cliffDuration,
        uint256 vestingDuration
    ) external onlyOwner {
        require(beneficiary != address(0), "Invalid address");
        require(totalAmount > 0, "Zero amount");
        require(vestingDuration > cliffDuration, "Invalid duration");
        require(vestings[beneficiary].total == 0, "Already exists");

        vestings[beneficiary] = VestingSchedule({
            total: totalAmount,
            released: 0,
            start: block.timestamp,
            cliff: block.timestamp + cliffDuration,
            duration: vestingDuration,
            revoked: false
        });

        emit VestingAdded(beneficiary, totalAmount);
    }

    function release() external {
        VestingSchedule storage v = vestings[msg.sender];
        require(v.total > 0, "No vesting");
        require(!v.revoked, "Vesting revoked");

        uint256 vested = vestedAmount(msg.sender);
        uint256 releasable = vested - v.released;
        require(releasable > 0, "Nothing to release");

        v.released += releasable;
        token.transfer(msg.sender, releasable);

        emit TokensReleased(msg.sender, releasable);
    }

    function revoke(address beneficiary) external onlyOwner {
        VestingSchedule storage v = vestings[beneficiary];
        require(v.total > 0, "No vesting");
        require(!v.revoked, "Already revoked");

        uint256 vested = vestedAmount(beneficiary);
        uint256 unreleased = vested - v.released;
        uint256 refund = v.total - vested;

        v.total = vested;
        v.released = vested;
        v.revoked = true;

        if (unreleased > 0) {
            token.transfer(beneficiary, unreleased);
        }

        if (refund > 0) {
            token.transfer(owner(), refund);
        }

        emit VestingRevoked(beneficiary);
    }

    function vestedAmount(address beneficiary) public view returns (uint256) {
        VestingSchedule memory v = vestings[beneficiary];

        if (block.timestamp < v.cliff) {
            return 0;
        }

        if (block.timestamp >= v.start + v.duration || v.revoked) {
            return v.total;
        }

        return (v.total * (block.timestamp - v.start)) / v.duration;
    }
}
