// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract OrcaCoinCointract is ERC20  { 
    //also write comments explaining each line of code
    address public stakingcontract;
    address public owner;
    constructor(address _stakingContract) ERC20("OrcaCoin","Orca"){
        owner=msg.sender;
        stakingcontract=_stakingContract;
    }
    function updatestakingcontract (address _newstakingcontract)public {
        require(msg.sender==owner);
        stakingcontract=_newstakingcontract;
    }

    function mint (address to,uint256 amount)public {
        require(msg.sender==stakingcontract);
        _mint(to,amount);
        
    }
}
