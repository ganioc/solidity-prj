pragma solidity  >=0.4.0 <=0.6.0;

contract Betting{
    address payable owner;
    uint minWager = 1;
    uint totalWager = 0;
    uint numberOfWagers = 0;
    uint constant MAX_NUMBER_OF_WAGERS = 2;
    uint winningNumber = 999;
    uint constant MAX_WINNING_NUMBER = 3;
    address payable [] playerAddresses;
    
    mapping (address => bool) playerAddressesMapping;
    
    struct Player{
        uint amountWagered;
        uint numberWagered;
    }
    
    mapping(address => Player) playerDetails;
    
    
    // constructor
    constructor (uint _minWager) public{
        owner = msg.sender;
        if(_minWager > 0) minWager = _minWager;
    }
    
    // Betting a numberWagered
    function bet(uint number) public payable{
        require(playerAddressesMapping[msg.sender] == false);
        
        // check the range of numberOfWagers
        require(number >= 1 && number <= MAX_WINNING_NUMBER);
        
        require( (msg.value/(1 ether)) >= minWager);
        
        playerDetails[msg.sender].amountWagered = msg.value;
        playerDetails[msg.sender].numberWagered = number;
        
        playerAddresses.push(msg.sender);
        playerAddressesMapping[msg.sender] = true;
        
        numberOfWagers++;
        totalWager += msg.value;
        
        if(numberOfWagers >= MAX_NUMBER_OF_WAGERS){
            announceWinners();
        }
    }
    
    function announceWinners() private{
        winningNumber = 
            uint(keccak256(abi.encodePacked(block.timestamp))) %
            MAX_WINNING_NUMBER + 1;
            
        address payable[MAX_NUMBER_OF_WAGERS] memory winners;
        
        uint winnerCount = 0;
        uint totalWinningWager = 0;
        
        for(uint i=0; i< playerAddresses.length; i++){
            
            address payable playerAddress =
                playerAddresses[i];
                
            if(playerDetails[playerAddress].numberWagered == winningNumber){
                winners[winnerCount] = playerAddress;
                
                totalWinningWager += 
                    playerDetails[playerAddress].amountWagered;
                winnerCount++;
            }
        }
        
        for(uint j=0; j< winnerCount; j++){
            winners[j].transfer(
                    (playerDetails[winners[j]].amountWagered/totalWinningWager) 
                        * totalWager); 
        }
        
    }
    function getWinningNumber() view public returns(uint){
        return winningNumber;
    }
    
    function kill() public{
        
        if(msg.sender == owner){
            selfdestruct(owner);
        }
    }
}