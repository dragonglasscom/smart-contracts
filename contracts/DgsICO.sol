pragma solidity ^0.4.18;

import "./DGS.sol";

contract DgsICO {

    DGS public dgsToken;

    address founder;

    uint public price = 1 * 10**17;             // temp value, will be changed
    uint public minInvestment = 1 * 10**16;     // temp value, will be changed
    uint public tokensLeft = 0;

    bool offeringClosed = false;

    function DgsICO( address _tokenAddress,
        address _founder) public {
            dgsToken = DGS(_tokenAddress);
            founder = _founder;
    }

    modifier onlyFounder {
        require(msg.sender == founder);
        _;
    }

    // Launch the ICO
    // Should be called after "setIcoAddress()" in DGS.sol
    function launch() public onlyFounder() {
        require(!offeringClosed);
        tokensLeft = dgsToken.balanceOf(this);
    }

    function () payable {
        require(!offeringClosed);
        require(msg.value >= minInvestment);
        require(tokensLeft > 0);
        uint _value = msg.value;

        uint tokensToBeSent = _value * 10**8 / price ;

        if (tokensLeft <= tokensToBeSent) {
            tokensToBeSent = tokensLeft;
            tokensLeft = 0;
            msg.sender.transfer(_value - (tokensToBeSent * price / 10**8));
            offeringClosed = true;
        }
        else
            tokensLeft -= tokensToBeSent;

        founder.transfer(this.balance);

        dgsToken.transfer(msg.sender,
            tokensToBeSent);
    }
}
