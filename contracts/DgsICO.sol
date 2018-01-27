pragma solidity ^0.4.18;

import "./DGS.sol";

contract DgsICO {

    DGS public dgsToken;

    address founder;

    uint public price = 27 * 10**12;
    uint public minInvestment = 1 * 10**15;
    uint public maxInvestment = 1 * 10**19;
    uint public tokensLeft = 0;

    bool offeringClosed = false;

    mapping (address => bool) validators;
    mapping (address => bool) verified;
    mapping (address => uint) investedAmount;

    function DgsICO( address _tokenAddress,
        address _founder) public {
            dgsToken = DGS(_tokenAddress);
            founder = _founder;
    }

    modifier onlyFounder {
        require(msg.sender == founder);
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender]);
        _;
    }

    // Launch the ICO
    // Should be called after "setIcoAddress()" in DGS.sol
    function launch() public onlyFounder() {
        require(!offeringClosed);
        tokensLeft = dgsToken.balanceOf(this);
    }

    function stop() public onlyFounder() {
        offeringClosed = false;
    }

    function addValidator(address _validator)
    public onlyFounder() {
        validators[_validator] = true;
    }

    function removeValidator(address _validator)
    public onlyFounder() {
        validators[_validator] = false;
    }

    function verifyAddress(address _address)
    public onlyValidator() {
        verified[_address] = true;
    }

    function removeVerifiedAddress(address _address)
    public onlyValidator() {
        verified[_address] = false;
    }

    function () payable {
        require(!offeringClosed);
        require(msg.value >= minInvestment);

        require(investedAmount[msg.sender] + msg.value <= maxInvestment
             || verified[msg.sender]);

        uint tokensToBeSent = msg.value * 10**8 / price ;

        if (tokensLeft <= tokensToBeSent) {
            tokensToBeSent = tokensLeft;
            tokensLeft = 0;
            msg.sender.transfer(msg.value - (tokensToBeSent * price / 10**8));
            offeringClosed = true;
        }
        else
            tokensLeft -= tokensToBeSent;

        founder.transfer(this.balance);

        dgsToken.transfer(msg.sender,
            tokensToBeSent);

        investedAmount[msg.sender] += tokensToBeSent * price / 10**8;
    }
}
