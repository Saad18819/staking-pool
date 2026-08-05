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

DAY 2



now when we do forge build or compile it will give error coz

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

foundry like solidity cant directly reach out to npm package repository and we need to explicitly mention from where to pull out the dependencies



now search on ggole smart contract chainlink brownie contract and open the github of that and then we have to dowload this repo

in terminal write  'forge install 'github repo link'@ version'      can check version from github repo
forge install smartcontractkit/chainlink-brownie-contracts@1.3.0

now when u open lib we can see forge-std library but can also see chainlink brownie thingy as well
but now the issue is in Fundme.sol and PriceConverter.sol
"import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";"

ye aggregator vali chiz me we want chainlink contract from brownie contract which we have downloaded so we go to foundry.toml to remapp it

1)forge build


2)get the api key from alchemy and put it in .env


coz we have harcoded the address 

3)source .env
4)forge test --fork-url $MAINNET_RPC_URL    to test if everything is working fine
















 */