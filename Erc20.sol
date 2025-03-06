// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract ERC20 {
    string public name="fobal";
    string public symbol="FO";
    uint public  decimal=18;
    uint totalsupply;
    address private owner;
    mapping(address=>uint) balance;
    mapping(address=>mapping(address=>uint))  allowance;
    event Transfer(address indexed from, address indexed to , uint value);
    event Approval(address indexed Owner,address indexed spender, uint value);
    constructor(uint initialsupply){
     
        totalsupply=initialsupply * (10 ** decimal);
        owner=msg.sender;
        balance[owner]=totalsupply;


    }
    function Totalsupply() public view returns (uint256){
        return totalsupply;
    }
    function balanceof(address user) public view returns(uint256){
        return balance[user];
    }

    function transfer(address _to, uint _value ) public {
        _value =_value * (10 ** decimal);
        require(balance[msg.sender]>=_value,"you dont have sufficient tokens ");
        balance[msg.sender]-=_value;
        balance[_to]+=_value;
        emit Transfer(msg.sender,_to,_value);

    }
    function approval(address _spender ,uint _value) public {
       _value=_value * (10 ** decimal);
        allowance[msg.sender][_spender]=_value;
        emit Approval(msg.sender,_spender,_value);

    }
    function Allowance(address _owner,address _spender) public view returns(uint){
        return allowance[_owner][_spender];
    }
    function transferFrom(address sender,address to,uint value) public{
        value=value * (10 ** decimal);
        require(balance[sender]>=value,"insufficient funds");
        require(allowance[sender][msg.sender]>=value,"limit exceed");
        balance[sender]-=value;
        balance[to]+=value;
        allowance[sender][msg.sender]-=value;
       emit Transfer(sender,to,value);


    }

}