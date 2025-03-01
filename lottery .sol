 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
 contract lottersystem{
    uint starttime;
    uint endtime;
    uint public constant lotteryticket = 10 * 1 ether;
    address private lotterwinner;
    bool private lotteryover;
    address private owner;
    bool moneytransfered;
    constructor(uint256 _starttime,uint _endtime){
        require(_starttime < _endtime,"invalid time, startime should be lesser thant endtime");
        require(_starttime>block.timestamp,"can set time in past");
        starttime=_starttime;
        endtime=_endtime;
        lotteryover=false;
        owner=msg.sender;
    }
    modifier onlyowner(){
        require(msg.sender==owner,"not the owner");
        _;
        
    }
    modifier  lotterbuy(){
        require(block.timestamp>starttime,"still not started");
        _;
    }
    modifier lotterend(){
        require(block.timestamp<endtime,"ended");
        _;
    }
    modifier declare(){
        require(block.timestamp>endtime,"lottery buying is still going on");
        _;
    }
    struct  user{
        string name;
        address wallet;
        bool  hasparticipated;


    }
    mapping(address => user) participants;
    user[] candidates;


    function  buylotter(string memory name) public payable {
        require(msg.value==lotteryticket," pay 10 ether to buy one lottery");
        require(participants[msg.sender].hasparticipated==false,"you aldready bought ticket");
        participants[msg.sender]=user(name,msg.sender,true);
        candidates.push(participants[msg.sender]);


    }
    function  Declarelottery() public  onlyowner returns(string  memory , address){
        require(lotteryover==false,"aldready declared");
         uint  index=uint(block.timestamp) % (candidates.length);
         lotterwinner=candidates[index].wallet;
         lotteryover=true;
         return (candidates[index].name , candidates[index].wallet);
        
   

    } 
    function Winnername() public onlyowner view returns(string memory , address){
        require(lotteryover==true,"winner is still not declared");
        return (participants[lotterwinner].name,participants[lotterwinner].wallet);
    }
    function transfermoneytowinner() public payable onlyowner{
        require(moneytransfered==false,"money aldready transfered");
        require(lotteryover==true,"winner is still not declared");
        moneytransfered=true;
        payable(lotterwinner).transfer(address(this).balance);

    }
 }