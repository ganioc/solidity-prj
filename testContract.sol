pragma solidity >=0.4.0 <=0.6.0; 

contract testContract{
    uint value;
    
    constructor(uint _p)public{
        value = _p;
    }
    function setP(uint _n) public payable{
        value = _n;
    }
    function setNP(uint _n)public{
        value = _n;
    }
    function get() public constant returns (uint){
        return value;
    }
    function getBalance() public constant returns(uint){
        return address(this).balance;
    }
}