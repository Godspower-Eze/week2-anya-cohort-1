//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GEToken is ERC20, Ownable {
    constructor() ERC20("Godspower Eze Token", "GET") {
        _mint(_msgSender(), 10e9 * (10**decimals()));
    }

    function mint(address reciever, uint256 amount) public onlyOwner {
        _mint(reciever, amount);
    }
}
