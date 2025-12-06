// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;
//ownable comtract
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Iccoin is ERC20{ 
    address public owner;
    constructor(uint initialSupply) ERC20("Iccoin", "IC") {
         _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
        owner = msg.sender;    
        }
        function mint(address to, uint amount) public {
            // require(msg.sender == owner, "Only owner can mint");
            _mint(to, amount);
        }


}
