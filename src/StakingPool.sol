// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract StakingPool{
  uint256 constant MINIMUM_USD = 100*1e18;



  error NotEnoughAmnt();

  address[] public stakers;
  mapping(address stakersAdd => uint256 stakersAmnt) public stakersAmnt;





function getPriceOfEthInUSD() public view returns(uint256){

(,int256 price,,,) = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419).latestRoundData();

return uint256(price*1e10);

}





function NetAmntInUSD(uint256 ethAmnt) public view returns(uint256){
    uint256 unitPrice = getPriceOfEthInUSD();
uint256 totalPrice = (unitPrice * ethAmnt)/1e18;
return totalPrice;

}





  function fund() public payable{
if(NetAmntInUSD(msg.value)<MINIMUM_USD){
    revert NotEnoughAmnt();

}
stakersAmnt[msg.sender] += msg.value;
  }



function withdraw() public{
uint256 amount = stakersAmnt[msg.sender];
stakersAmnt[msg.sender] = 0;
(bool callSuccess, ) =payable(msg.sender).call{value:amount}("");
if(!callSuccess){
    revert NotEnoughAmnt();
}

}


}





/*
STEP BY STEP EXPLANATION

DAY 0
1)Make folder

2)forge init
then like write a basic code in src,script and test to check if ervything is working fine

3)forge build
if everything is working fine then start writing code 

DAY 1
started writing a code in src basic logic and then wrote a deployed script code and also wrote a test thing in test file















 */