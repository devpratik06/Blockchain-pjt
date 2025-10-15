# 🗳️ Sentiment-Influenced Voting Smart Contract

A simple Solidity smart contract that allows users to vote on a proposal, with vote **weights influenced by sentiment analysis scores**.

Since sentiment analysis cannot be performed on-chain, this contract accepts a manually submitted sentiment score (from -100 to +100), which is used to dynamically calculate vote weight.

---

## 📌 Features

- ✅ No imports
- ✅ No constructors
- ✅ No input parameters
- ✅ Fully on-chain vote counting
- 🧠 Off-chain sentiment score can be submitted manually
- ⚖️ Votes are weighted based on sentiment (positive = higher weight)

---

## 🔧 How It Works

1. **Sentiment Score Submitted**  
   A sentiment score between `-100` and `+100` is pushed to the contract using `updateSentimentScore()`.

2. **Users Vote**  
   Users cast a "yes" or "no" vote using the `vote(bool voteYes)` function. Their vote is automatically weighted based on the current sentiment score.

3. **Result Calculation**  
   The contract calculates the winner based on the total weighted votes.

---

## 🛠️ Functions

### `updateSentimentScore(int256 score)`
Submit a new sentiment score. Must be between `-100` (very negative) and `+100` (very positive).

```solidity
function updateSentimentScore(int256 score) public;
