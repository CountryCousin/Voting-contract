// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Vote{

    struct Candidate{
        string name;
        uint voteCount;
    }

    struct Voter {
        bool voted;
        uint voteIndex;
        uint weight;
    }

    address public owner;
    string public name;
    mapping(address =>Voter) public voters;
    Candidate[] public candidates;
    uint public votingEnd;

//    function Election(string memory name, uint durationMinutes, string[] memory candidateNames)public{
       
//    } 

     event ElectionResult(string name, uint voteCount);

   function Election(string memory _name, uint durationMinutes, string memory candidate1, string memory candidate2)public{
       owner = msg.sender;
       name = _name;
       votingEnd = block.timestamp + (durationMinutes * 1 minutes);

       candidates.push(Candidate(candidate1,0));
       candidates.push(Candidate(candidate2,0));
   }

   function autorized(address voter) public{
       require(msg.sender == owner);
       require(!voters[voter].voted);


       voters[voter].weight = 1;
   }

   function votingPeriod(uint voteIndex) public{
       require(block.timestamp < votingEnd);
       require(!voters[msg.sender].voted);

       voters[msg.sender].voted = true;
       voters[msg.sender].voteIndex = voteIndex;

       candidates[voteIndex].voteCount += voters[msg.sender].weight;

   }

   function endVoting() public {
       require(msg.sender == owner);
       require(block.timestamp >= votingEnd);

       for(uint i = 0; i < candidates.length; i++){
          emit ElectionResult(candidates[i].name, candidates[i].voteCount);
       }
   }

    
}