// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVotingToken {
    function mint(address to, uint256 amount) external;
}

contract VotingSystem {
    struct Candidate {
        string name;
        uint votes;
    }

    address public admin;
    bool public votingActive;
    IVotingToken public token;

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    constructor(address tokenAddress) {
        admin = msg.sender;
        token = IVotingToken(tokenAddress);
    }

    function addCandidate(string memory name) external {
        require(msg.sender == admin, "Only admin can add candidates");
        candidates.push(Candidate(name, 0));
    }

    function startVoting() external {
        require(msg.sender == admin, "Only admin can start voting");
        votingActive = true;
    }
    function vote(uint index) external {
        require(votingActive, "Voting not active");
        require(!hasVoted[msg.sender], "Already voted");

        candidates[index].votes++;
        hasVoted[msg.sender] = true;

        token.mint(msg.sender, 10 * 10**18);
    }

    function getCandidatesCount() external view returns (uint) {
        return candidates.length;
    }
}