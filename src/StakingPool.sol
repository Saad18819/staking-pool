// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract StakingPool{
    address immutable public owner;
    constructor(){
        owner = msg.sender;
    }
}