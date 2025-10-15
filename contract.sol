// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SentimentVoting {
    string public proposal = "Should we launch the new product?";
    int256 public sentimentScore; // Ranges from -100 to +100

    enum VoteOption { None, Yes, No }

    struct Voter {
        bool hasVoted;
        VoteOption vote;
        uint256 weight;
    }

    mapping(address => Voter) public voters;

    uint256 public totalYesVotes;
    uint256 public totalNoVotes;

    event SentimentUpdated(int256 newScore);
    event Voted(address indexed voter, VoteOption vote, uint256 weight);

    /// @notice Submit a new sentiment score from -100 (very negative) to +100 (very positive)
    function updateSentimentScore(int256 score) public {
        require(score >= -100 && score <= 100, "Score must be between -100 and 100");
        sentimentScore = score;
        emit SentimentUpdated(score);
    }

    /// @notice Vote yes (true) or no (false) on the proposal
    function vote(bool voteYes) public {
        require(!voters[msg.sender].hasVoted, "Already voted");

        uint256 weight = _calculateWeight(sentimentScore);

        if (voteYes) {
            totalYesVotes += weight;
            voters[msg.sender] = Voter(true, VoteOption.Yes, weight);
        } else {
            totalNoVotes += weight;
            voters[msg.sender] = Voter(true, VoteOption.No, weight);
        }

        emit Voted(msg.sender, voteYes ? VoteOption.Yes : VoteOption.No, weight);
    }

    function _calculateWeight(int256 score) internal pure returns (uint256) {
        // Convert sentiment to a vote weight from 1 to 10
        // score: -100 -> 1, 0 -> 5, +100 -> 10
        int256 base = (score + 100) * 9 / 200 + 1; // scaled to [1,10]
        return uint256(base);
    }

    function getResult() public view returns (string memory result, uint256 yesVotes, uint256 noVotes) {
        if (totalYesVotes > totalNoVotes) {
            result = "Proposal PASSED";
        } else if (totalNoVotes > totalYesVotes) {
            result = "Proposal REJECTED";
        } else {
            result = "TIED";
        }

        yesVotes = totalYesVotes;
        noVotes = totalNoVotes;
    }
}
