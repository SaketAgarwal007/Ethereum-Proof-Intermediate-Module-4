// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    mapping(uint256 => uint256) public storeItems;
    mapping(address => uint256[]) public userItems;

    constructor() ERC20("DegenToken", "DGN") Ownable(msg.sender){
        storeItems[1] = 80;
        storeItems[2] = 90;
        storeItems[3] = 110;
        storeItems[4] = 100;
    }

    function mintTokens(address recipient, uint256 amount) public onlyOwner {
        _mint(recipient, amount);
    }

    function transferTokens(address recipient, uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(recipient, amount);
    }

    function redeemItem(uint256 itemId) public {
        require(itemId > 0 && itemId <= 4, "Invalid item");
        require(balanceOf(msg.sender) >= storeItems[itemId], "Insufficient balance");
        transfer(owner(), storeItems[itemId]);
        userItems[msg.sender].push(itemId);
    }

    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }

    function transferItem(address recipient, uint256 itemId) public {
        require(itemId > 0 && itemId <= 4, "Invalid item");
        require(userItems[msg.sender].length > 0, "No items to transfer");
        uint256 length = userItems[msg.sender].length;
        bool found = false;
        for (uint256 i = 0; i < length; i++) {
            if (userItems[msg.sender][i] == itemId) {
                found = true;
                userItems[msg.sender][i] = userItems[msg.sender][length - 1];
                userItems[msg.sender].pop();
                userItems[recipient].push(itemId);
                break;
            }
        }
        require(found, "Item not found in inventory");
    }

    function getUserItems(address user) public view returns (uint256[] memory) {
        return userItems[user];
    }
}
