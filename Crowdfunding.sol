/**
 *Submitted for verification at Etherscan.io on 2024-09-05
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    mapping(address => uint) public contributions;
    bool public goalReached;
    bool public fundsWithdrawn;

    constructor(uint _goal, uint _time) {
        owner = msg.sender;
        goal = _goal;
        deadline = block.timestamp + _time;
        goalReached = false;
        fundsWithdrawn = false;
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "Crowdfunding is Ended");
        require(msg.value > 0, "Amount must be greater than 0");

        contributions[msg.sender] += msg.value;
    }

    function checkGoalReached() public {
        require(block.timestamp >= deadline, "Crowdfunding is still ongoing");

        if (address(this).balance >= goal) {
            goalReached = true;
        }
    }

    function withdrawFunds() public {
        require(msg.sender == owner, "You are not the owner");
        require(goalReached, "Goal is not reached");  //
        require(!fundsWithdrawn, "Funds are already withdrawn");

        fundsWithdrawn = true;
        payable(owner).transfer(address(this).balance);
    }

    function refund() public {
        require(block.timestamp >= deadline, "Crowdfunding is still ongoing");
        require(!goalReached, "Thankyou for your contributions, Refunds are not available");

        uint amount = contributions[msg.sender];
        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}