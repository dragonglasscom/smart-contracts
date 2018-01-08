pragma solidity ^0.4.11;

import "./DGS.sol";

contract DgsICO {

    DGS public dgsToken;

    address founder1;
    address founder2;

    uint public price = 100000000000000000;
    uint public minInvestment = 10000000000000000;
    uint public tokensLeft = 0;

    bool offeringClosed = true;
    bool initialOffering = true;

    mapping ( uint => address) truestedContracts;

    function DgsICO( address _tokenAddress,
        address _founder1,
        address _founder2
        ) public {
            dgsToken = DGS(_tokenAddress);
            founder1 = _founder1;
            founder2 = _founder2;
    }

    modifier onlyFounder {
        require(msg.sender == founder1 ||
            msg.sender == founder2);
        _;
    }

    // Launch the ICO
    // Should be called after "setIcoAddress()" in DGS.sol
    function launch() public onlyFounder() {
        require(initialOffering);
        tokensLeft = dgsToken.balanceOf(this);
        offeringClosed = false;
    }

    function withdraw(uint amount) public onlyFounder() {
        require(this.balance <= amount);
        msg.sender.transfer(amount);
    }

    function () payable {
        require(!offeringClosed);
        require(msg.value >= minInvestment);
        require(tokensLeft > 0);
        uint _value = msg.value;

        uint tokensToBeSent = _value / price * 10**8;

        if (tokensLeft <= tokensToBeSent) {
            tokensToBeSent = tokensLeft;
            tokensLeft = 0;
            offeringClosed = true;
        }

        tokensLeft -= tokensToBeSent;

        dgsToken.transfer(msg.sender,
            tokensToBeSent);

        if (offeringClosed) {
            dgsToken.icoFinished();
            initialOffering = false;
        }
    }
}
