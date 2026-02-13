# Escrow Guide

**With Escrow (Our Contract):**
1. 💰 You send money to the **contract** (not to seller)
2. 📦 Seller ships laptop
3. ✅ You confirm delivery
4. 💸 Contract automatically sends money to seller

**The contract is like a robot referee - it holds the money safely!**

---

## 🧩 Understanding the Basics

### What is an Address?
```
Example: 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb
```
- It's like a bank account number
- Everyone on Ethereum has one
- Your MetaMask wallet has an address

### What is ETH and Wei?
- **ETH** = The cryptocurrency (like dollars)
- **Wei** = Smallest unit of ETH (like cents)
- 1 ETH = 1,000,000,000,000,000,000 wei (18 zeros!)

### What is "msg.sender"?
- The address of whoever is calling the function RIGHT NOW
- If YOU call a function, msg.sender = YOUR address

### What is "require"?
```solidity
require(condition, "error message");
```
- If condition is FALSE → STOP everything and show error
- If condition is TRUE → Continue

---

## 🛠️ HOW TO USE THIS CONTRACT (Step-by-Step)

### STEP 1: Open Remix IDE

1. Go to: https://remix.ethereum.org
2. You'll see a code editor (like Word but for code)

### STEP 2: Create Your Contract File

1. On the left, click the 📄 icon (File Explorer)
2. Click "contracts" folder
3. Click the 📄 with + icon (New File)
4. Name it: `BeginnerEscrow.sol`
5. Copy and paste the contract code into it

### STEP 3: Compile (Check for Errors)

1. Click the 🔧 icon on left (Solidity Compiler)
2. Select version: `0.8.24` or higher
3. Click big blue button: "Compile BeginnerEscrow.sol"
4. ✅ If you see green checkmark = SUCCESS!
5. ❌ If you see red errors = copy them and ask for help

### STEP 4: Deploy (Create Your Contract)

1. Click the 🚀 icon on left (Deploy & Run)
2. At top, select Environment: **"Remix VM (Shanghai)"**
   - This is a fake blockchain for testing (FREE!)
3. You'll see some fake accounts with 100 ETH each
4. Under "Deploy" section:
   - **_SELLER**: Paste an address (use one of the fake accounts shown above)
   - **_PRICE**: Enter amount in wei
     - For 1 ETH, type: `1000000000000000000` (1 with 18 zeros)
     - For 0.1 ETH, type: `100000000000000000` (1 with 17 zeros)
5. Click orange "Deploy" button
6. ✅ Contract appears under "Deployed Contracts"!

---

## 🎮 TESTING YOUR CONTRACT 

Now you have 3 addresses:
- **BUYER** = The account that deployed (you)
- **SELLER** = The address you typed in
- **CONTRACT** = The deployed contract address

### TEST 1: Buyer Deposits Money

1. Make sure the **first account** is selected (this is buyer)
2. In the "VALUE" box at top:
   - Enter the SAME amount you set as price
   - Change dropdown to "wei"
3. Click the red "deposit" button
4. Check "getBalance" → Should show your money!
5. Check "getStatus" → Should say "Waiting for delivery confirmation"

### TEST 2: Buyer Confirms Delivery

1. Still using buyer account (first account)
2. Click "confirmDelivery" button (orange)
3. Check "getBalance" → Should be 0 (money sent to seller!)
4. Check "getStatus" → Should say "Deal completed!"
5. ✅ SUCCESS! Seller got the money!

### TEST 3: Try Refund (Reset and Try Again)

Deploy a NEW contract and:
1. Buyer deposits money
2. Instead of "confirmDelivery", click "refund"
3. Money comes back to buyer!

---

## 📖 UNDERSTANDING THE CODE LINE BY LINE

### The Constructor (Setup)
```solidity
constructor(address _seller, uint256 _price) {
    buyer = msg.sender;  // Person deploying = buyer
    seller = _seller;     // Address you typed = seller
    price = _price;       // Price you typed
}
```
**What it does:** Saves who is buyer, seller, and the price

### The Deposit Function
```solidity
function deposit() public payable {
    require(msg.sender == buyer, "Only buyer can deposit!");
    require(isBuyerIn == false, "Already deposited!");
    require(msg.value == price, "Must send exact price!");
    
    isBuyerIn = true;
    emit MoneyDeposited(msg.sender, msg.value);
}
```
**What it does:**
1. Checks it's the buyer calling
2. Checks buyer hasn't already deposited
3. Checks they sent exact price
4. Remembers money is deposited
5. Sends notification

### The Confirm Delivery Function
```solidity
function confirmDelivery() public {
    require(msg.sender == buyer, "Only buyer can confirm!");
    require(isBuyerIn == true, "No money deposited yet!");
    
    isComplete = true;
    payable(seller).transfer(price);
    emit MoneyReleased(seller, price);
}
```
**What it does:**
1. Checks it's the buyer
2. Checks money was deposited
3. Marks as complete
4. **Sends money to seller**
5. Sends notification

---

## 🐛 COMMON MISTAKES (And How to Fix)

### Mistake 1: "Only buyer can deposit!"
**Problem:** You're using the wrong account
**Fix:** Switch to the account that deployed the contract

### Mistake 2: "Must send exact price!"
**Problem:** You sent wrong amount
**Fix:** Make sure VALUE matches the price you set

### Mistake 3: "Already deposited!"
**Problem:** You already called deposit
**Fix:** Deploy a new contract to start over

### Mistake 4: Contract has 0 balance
**Problem:** You forgot to send value with deposit
**Fix:** Fill in the VALUE box before clicking deposit

---