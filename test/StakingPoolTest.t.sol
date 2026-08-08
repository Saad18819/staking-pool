// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;


import{Test} from "forge-std/Test.sol";
import{DeployStakingPool} from "../script/DeployStakingPool.s.sol";
import {StakingPool} from "../src/StakingPool.sol";

contract StakingTest is Test{

    StakingPool stakess;

    function setUp() external{
    DeployStakingPool newDeploy = new DeployStakingPool();
    stakess = newDeploy.run();
    vm.deal(address(stakess),1000 ether);
    }

uint256 constant dummyMoney = 1000 ether;
uint256 constant money = 10 ether;
address DummyAdd = makeAddr("Saad");

function testfund() external{

    hoax(DummyAdd,dummyMoney);
    stakess.fund{value:dummyMoney}();

}



function testDayZeroWithdraw() external{
    hoax(DummyAdd , dummyMoney);
    stakess.fund{value:money}();
    vm.warp(block.timestamp);

   vm.prank(DummyAdd);
    stakess.withdraw();
    assertEq(DummyAdd.balance , dummyMoney);
}

function testDayThreeWithdraw() external{
      hoax(DummyAdd , dummyMoney);
    stakess.fund{value:money}();
    vm.warp(block.timestamp + 3 days);
   vm.prank(DummyAdd);
    stakess.withdraw();
    uint256 profit = (6*money)/100;
    assertEq(DummyAdd.balance , profit + dummyMoney);
}

function testDaySevenWithdraw() external{
        hoax(DummyAdd , dummyMoney);
    stakess.fund{value:money}();
    vm.warp(block.timestamp + 7 days);
   vm.prank(DummyAdd);
    stakess.withdraw();
    uint256 profit = (10 * money)/100;
    assertEq(DummyAdd.balance , profit + dummyMoney);
}








}



/*
LEARNING



Here is the exact mental model for when to use forge test vs. forge script:

1. forge test (Your Daily Workhorse)
When to use: 95% of your development time.

What it does: It creates a temporary, throwaway in-memory blockchain in milliseconds, deploys your contracts there, runs your tests, and destroys the blockchain immediately after.

Why: It's super fast, completely free (no RPC calls or gas costs), and gives you instant feedback on bugs.

2. forge script (When You're Ready to Deploy or Interact)
When to use: Only when you want to actually broadcast transactions to a real, persisting blockchain.

Where you send it:

Local: Your local anvil node running on your computer.

Testnet: Ethereum Sepolia, Arbitrum Sepolia, etc.

Mainnet: Ethereum Mainnet, Polygon, Base, etc.

What it does: It runs your script (like DeployStakingPool.s.sol), signs transactions with a private key (--private-key), and broadcasts them to the target network using --rpc-url.


3)vm.warp

vm.warp is a Foundry cheatcode that allows you to manipulate blockchain time during unit tests. It sets the block timestamp (block.timestamp or block.timestamp in Solidity) directly to a specific timestamp in the future.
basically acts like a time machine 
Smart contracts cannot "wait" for days or years to pass in real time during a test. If your contract relies on time-based logic:
...you use vm.warp to teleport the blockchain into the future in milliseconds.






 */