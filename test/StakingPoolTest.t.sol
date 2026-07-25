// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import{DeployStakingPool} from "../script/DeployStakingPool.s.sol";
import {StakingPool} from "../src/StakingPool.sol";
import {Test} from "forge-std/Test.sol";

contract StakingPoolTest is Test{

DeployStakingPool testStakes;
StakingPool stakes;
//setup function shld be public or external coz while testing external framework gonna call it

function setup() public{

testStakes = new DeployStakingPool();
stakes = testStakes.run();
}

function testDemo() public{
    assertEq(stakes.owner(),address(testStakes));
}

}
