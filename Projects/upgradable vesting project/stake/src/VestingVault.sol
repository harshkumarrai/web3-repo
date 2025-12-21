// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VestingVault is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    IERC20 public token;

    struct Vesting {
        uint256 total;
        uint256 released;
        uint64 start;
        uint64 cliff;
        uint64 duration;
        bool revoked;
    }

    mapping(address => Vesting) public vestings;

    event VestingCreated(address indexed beneficiary, uint256 amount);
    event TokensReleased(address indexed beneficiary, uint256 amount);
    event VestingRevoked(address indexed beneficiary);

    function initialize(address _token, address owner_) external initializer {
        __Ownable_init(owner_);
        // __UUPSUpgradeable_init();

        token = IERC20(_token);
    }

    function _authorizeUpgrade(address) internal override onlyOwner {}

    function createVesting(
        address beneficiary,
        uint256 amount,
        uint64 start,
        uint64 cliffDuration,
        uint64 duration
    ) external onlyOwner {
        require(vestings[beneficiary].total == 0, "Already exists");
        require(cliffDuration <= duration, "Invalid cliff");

        vestings[beneficiary] = Vesting({
            total: amount,
            released: 0,
            start: start,
            cliff: start + cliffDuration,
            duration: duration,
            revoked: false
        });

        require(
            token.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );

        emit VestingCreated(beneficiary, amount);
    }

    function vestedAmount(address beneficiary) public view returns (uint256) {
        Vesting memory v = vestings[beneficiary];

        if (block.timestamp < v.cliff) return 0;
        if (v.revoked) return v.released;

        if (block.timestamp >= v.start + v.duration) {
            return v.total;
        }

        return (v.total * (block.timestamp - v.start)) / v.duration;
    }

    function releasable(address beneficiary) public view returns (uint256) {
        return vestedAmount(beneficiary) - vestings[beneficiary].released;
    }

    function release() external {
        Vesting storage v = vestings[msg.sender];
        uint256 amount = releasable(msg.sender);
        require(amount > 0, "Nothing to release");

        v.released += amount;
        require(token.transfer(msg.sender, amount), "Transfer failed");

        emit TokensReleased(msg.sender, amount);
    }

    function revoke(address beneficiary) external onlyOwner {
        Vesting storage v = vestings[beneficiary];
        require(!v.revoked, "Already revoked");

        uint256 vested = vestedAmount(beneficiary);
        uint256 refund = v.total - vested;

        v.revoked = true;

        if (refund > 0) {
            token.transfer(owner(), refund);
        }

        emit VestingRevoked(beneficiary);
    }
}
