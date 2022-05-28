//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ST_GEToken is ERC20, Ownable {
    constructor() ERC20("Synthetic Godspower Eze Token", "SGET") {
        _mint(_msgSender(), 10e9 * (10**decimals()));
    }

    function mint(address reciever, uint256 amount) public onlyOwner {
        _mint(reciever, amount);
    }
}
