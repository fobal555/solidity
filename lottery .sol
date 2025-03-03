 // SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
 contract LotterySystem{
    uint starttime;
    uint endtime;
    uint public constant lotteryticket = 10 * 1 ether;
    address private lotteryWinner;
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
    modifier  lotteryBuyingTime(){
        require(block.timestamp>starttime,"Buying lottery still not started");
        _;
    }
    modifier lotteryEndingTime(){
        require(block.timestamp<endtime,"Lottery buying is over ");
        _;
    }
    modifier declare(){
        require(block.timestamp>endtime,"Lottery buying is still going on");
        _;
    }
    struct  User{
        string name;
        address wallet;
        bool  hasparticipated;


    }
    mapping(address => User) participants;
    User[] candidates;


    function  buyLottery(string memory name) public payable lotteryBuyingTime lotteryEndingTime{
        require(msg.value==lotteryticket," pay 10 ether to buy one lottery ");
        require(participants[msg.sender].hasparticipated==false,"you aldready bought ticket");
        participants[msg.sender]=User(name,msg.sender,true);
        candidates.push(participants[msg.sender]);


    }
    function  declareLotteryWinner() public  onlyowner returns(string  memory , address){
        require(lotteryover==false,"aldready declared");
         uint  index=uint(block.timestamp) % (candidates.length);
         lotteryWinner=candidates[index].wallet;
         lotteryover=true;
         return (candidates[index].name , candidates[index].wallet);
        
   

    } 
    function WinnerName() public onlyowner view returns(string memory , address){
        require(lotteryover==true,"winner is still not declared");
        return (participants[lotteryWinner].name,participants[lotteryWinner].wallet);
    }
    function transferMoneyToOwner() public payable onlyowner{
        require(moneytransfered==false,"money aldready transfered");
        require(lotteryover==true,"winner is still not declared");
        moneytransfered=true;
        payable(lotteryWinner).transfer(address(this).balance);

    }
 }