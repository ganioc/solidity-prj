pragma solidity >=0.4.0 <=0.6.0; 

contract ProofOfExistence {
    
    mapping (bytes32 => bool) private proofs;
    
    event DocumentNotarized(
        address from,
        string text,
        bytes32 hash);
    event NotarizationError(
        address from,
        string text,
        string reason
        );
    
    function storeProof(bytes32 proof) private {
        proofs[proof] = true;
    }
    function notarize(string memory document) public payable{
        // storeProof(proofFor(document));
        if(proofs[proofFor(document)]){
            emit NotarizationError(msg.sender, document,
            "String was stored previously");
            
            // retrun back to the sender;
            msg.sender.transfer(msg.value);
            
            return;
        }
        
        if(msg.value != 1000 wei){
            emit NotarizationError(msg.sender, document,
            "Incorrect amount of Ether paid");
            
            msg.sender.transfer(msg.value);
            
            return;
        }
        
        storeProof(proofFor(document));
        emit DocumentNotarized(msg.sender, document,
            proofFor(document));
    }
    // get a document's sha256
    function proofFor(string memory document) private pure returns (bytes32){
        return sha256(bytes(document));
    }
    
    function checkDocument(string memory document) public view returns(bool){
        return proofs[proofFor(document)];
    }
}