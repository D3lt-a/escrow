pragma solidity ^0.8.24;

/**
 *  ESCROW CONTRACT
 * 
 * What does this do?
 * - Buyer sends money to the contract (not directly to seller)
 * - Seller delivers the product/service
 * - Buyer confirms delivery
 * - Contract sends money to seller
 * 
 * Why? Because buyer and seller don't trust each other!
 */

contract SimpleEscrow {
   address public buyer;      // Who is buying (their wallet address)
    address public seller;     // Who is selling (their wallet address)
    uint256 public price;      // How much money (in wei, smallest ETH unit)
    bool public isBuyerIn;     // Has buyer deposited money? true/false
    bool public isComplete;    // Is deal finished? true/false
    
    // ========== EVENTS (Notifications) ==========
    // These are like receipts - they create logs we can see later
    
    event MoneyDeposited(address buyer, uint256 amount);
    event MoneyReleased(address seller, uint256 amount);
    event MoneyRefunded(address buyer, uint256 amount);
    
    constructor(address _seller, uint256 _price) {
        // The person deploying the contract becomes the buyer
        // We save the Seller's Address and the Price
        // At first no money is deposited and deal is not complete
        buyer = msg.sender;
        seller = _seller;
        price = _price;
        isBuyerIn = false;
        isComplete = false;
    }
    
    // ========== STEP 4: DEPOSIT FUNCTION (Buyer sends money) ==========
    
    function deposit() public payable {
        // WHAT IS "payable"? It means this function can receive ETH       
        // WHAT IS "msg.sender"? The address of whoever calls this function
        // WHAT IS "msg.value"? How much ETH they sent (in wei)  
        // CHECK 1: Only buyer can deposit
        // CHECK 2: Buyer hasn't already deposited
        // CHECK 3: Must send exact price amount
        // CHECK 4: Deal must not be complete
        require(msg.sender == buyer, "Only buyer can deposit!");        
        require(isBuyerIn == false, "Already deposited!");        
        require(msg.value == price, "Must send exact price!");        
        require(isComplete == false, "Deal already finished!");    
        isBuyerIn = true;
        
        emit MoneyDeposited(msg.sender, msg.value);
    }
    
    // ========== CONFIRM DELIVERY (Buyer approves) ==========
    
    function confirmDelivery() public {
        // Buyer calls this after receiving the product
        // CHECK 1: Only buyer can confirm
        // CHECK 2: Money must be deposited
        // CHECK 3: Not already complete
        require(msg.sender == buyer, "Only buyer can confirm!");
        require(isBuyerIn == true, "No money deposited yet!");
        require(isComplete == false, "Already complete!");

        isComplete = true;
        payable(seller).transfer(price);

        emit MoneyReleased(seller, price);
    }
    
    // ========== REFUND (If something goes wrong) ==========
    
    function refund() public {
        // Buyer calls this to get money back
        // CHECK 1: Only buyer can request refund
        // CHECK 2: Money must be deposited
        // CHECK 3: Not already complete
        require(msg.sender == buyer, "Only buyer can refund!");
        require(isBuyerIn == true, "No money to refund!");
        require(isComplete == false, "Deal already finished!");

        // Reset the deposit flag
        isBuyerIn = false;
        payable(buyer).transfer(price);

        emit MoneyRefunded(buyer, price);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
    
    function getStatus() public view returns (string memory) {
        if (isComplete) {
            return "Deal completed!";
        } else if (isBuyerIn) {
            return "Waiting for delivery confirmation";
        } else {
            return "Waiting for buyer deposit";
        }
    }
}
