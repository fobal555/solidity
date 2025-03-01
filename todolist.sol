// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
contract Todolist{
    struct task{
        string description;
        bool iscompleted;

    }
     mapping(address=>task[]) private usertasks;
     function addtask(string memory _description) public{
        usertasks[msg.sender].push(task(_description,false));
     }
     function completetask(uint index) public {
        require(index<usertasks[msg.sender].length,"invalid task to complete");
        usertasks[msg.sender][index].iscompleted=true;

     }
     function reviewtask() public view returns(task[] memory ){
        return usertasks[msg.sender];

     }
     function reviewspecfictask(uint _index) public view returns(string memory , bool){
        task memory t1=usertasks[msg.sender][_index];
        return (t1.description,t1.iscompleted );


     }
}
