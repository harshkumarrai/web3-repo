// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

contract CrowdFund {
    struct Campaign {
        address creator;
        uint256 goal;
        uint256 deadline;
        uint256 raised;
        bool withdrawn;
    }

    uint256 public campaignCount;

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public contributions;

    event CampaignCreated(
        uint256 indexed id,
        address indexed creator,
        uint256 goal,
        uint256 deadline
    );

    event Contributed(
        uint256 indexed id,
        address indexed contributor,
        uint256 amount
    );

    event Withdrawn(uint256 indexed id, uint256 amount);
    event Refunded(uint256 indexed id, address indexed contributor, uint256 amount);

    function createCampaign(uint256 _goal, uint256 _duration) external {
        require(_goal > 0, "Goal must be > 0");
        require(_duration > 0, "Duration must be > 0");

        campaignCount++;

        campaigns[campaignCount] = Campaign({
            creator: msg.sender,
            goal: _goal,
            deadline: block.timestamp + _duration,
            raised: 0,
            withdrawn: false
        });

        emit CampaignCreated(
            campaignCount,
            msg.sender,
            _goal,
            block.timestamp + _duration
        );
    }

    function contribute(uint256 _id) external payable {
        Campaign storage c = campaigns[_id];

        require(block.timestamp < c.deadline, "Campaign ended");
        require(msg.value > 0, "Zero contribution");

        c.raised += msg.value;
        contributions[_id][msg.sender] += msg.value;

        emit Contributed(_id, msg.sender, msg.value);
    }

    function withdraw(uint256 _id) external {
        Campaign storage c = campaigns[_id];

        require(msg.sender == c.creator, "Not creator");
        require(block.timestamp >= c.deadline, "Not ended");
        require(c.raised >= c.goal, "Goal not reached");
        require(!c.withdrawn, "Already withdrawn");

        c.withdrawn = true;

        (bool success, ) = payable(c.creator).call{value: c.raised}("");
        require(success, "ETH transfer failed");

        emit Withdrawn(_id, c.raised);
    }

    function refund(uint256 _id) external {
        Campaign storage c = campaigns[_id];

        require(block.timestamp >= c.deadline, "Not ended");
        require(c.raised < c.goal, "Goal reached");

        uint256 amount = contributions[_id][msg.sender];
        require(amount > 0, "Nothing to refund");

        contributions[_id][msg.sender] = 0;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");

        emit Refunded(_id, msg.sender, amount);
    }
}
