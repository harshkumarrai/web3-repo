// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakeContract {
    mapping (address => uint)mp1;  //balance
    mapping(address =>unint)unclaimedawards;
    mapping(address=>unint)lastupdatedtime;
    // mapping(address=> unint)rewards;

    // mapping(address=>)m
    constructor(){

    }
    function stake(uint256 amount) payable public {
        require(msg.value>0);
        if(!lastupdatedtime[msg.sender]){
            lastupdatedtime[msg.sender]=block.timestamp;
        }else{
            unclaimedawards[msg.sender]=(block.timestamp-lastupdatedtime[msg.sender])*mp1[msg.sender];
            lastupdatedtime[msg.sender]=block.timestamp;
        }
        mp1[msg.sender]+=msg.value;
    }
    function unstake(uint256 amount)public{
        require(mp1[msg.sender]>=amount);
        mp1[msg.sender]-=amount;
        payable(msg.sender).transfer(amount);
    }
    function claimrewards()public{
     uint currentrewards=unclaimedawards[_address];
        uint updatetime=lastupdatedtime[_address];
        uint newreward=(block.timestamp-updatetime)*mp1[_address];
        unclaimedawards[msg.sender]=0;
        lastupdatedtime[msg.sender]=block.timestamp;
    }
    function getrewards(address _address)public{
        uint currentrewards=unclaimedawards[_address];
        uint updatetime=lastupdatedtime[_address];
        uint newreward=(block.timestamp-updatetime)*mp1[_address];
        return newreward+currentrewards;

    }
    function balanceof()public view returns (uint) {
        return mp1[msg.sender];
    }
}