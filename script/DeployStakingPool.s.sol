// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {StakingPool} from "../src/StakingPool.sol";

contract DeployStakingPool is Script{

function run() external returns(StakingPool){


    vm.startBroadcast();
StakingPool stakes = new StakingPool();
    vm.stopBroadcast();

    return stakes;



}

}