pragma solidity ^0.4.18;

import "./DGS.sol";
import "./SafeMath.sol";

contract DgsICO {

    DGS public dgsToken;

    address founder;

    uint public constant PRICE = 27 * 10**12;
    uint public constant MIN_INVESTMENT = 1 * 10**15;
    uint public constant MAX_INVESTMENT = 1 * 10**19;
    uint public constant DECIMALS = 8;
    uint public constant DECIMAL_INDEX = 10**DECIMALS;

    uint public tokensLeft = 0;

    bool public offeringClosed = false;
    bool public offeringPaused = true;

    mapping (address => bool) validators;
    mapping (address => bool) verified;
    mapping (address => uint) investedAmount;

    function DgsICO(address _tokenAddress,
        address _founder) public {
            dgsToken = DGS(_tokenAddress);
            founder = _founder;
    }

    function () public payable {
        require(!offeringClosed && !offeringPaused);
        require(msg.value >= MIN_INVESTMENT);

        require(investedAmount[msg.sender] + msg.value <= MAX_INVESTMENT
             || verified[msg.sender]);

        uint tokensToBeSent = msg.value * DECIMAL_INDEX / PRICE;
        uint overpaid = 0;

        if (tokensLeft <= tokensToBeSent) {
            tokensToBeSent = tokensLeft;
            tokensLeft = 0;
            offeringClosed = true;
            overpaid = msg.value - (tokensToBeSent * PRICE / DECIMAL_INDEX);
        }
        else
            tokensLeft -= tokensToBeSent;

        investedAmount[msg.sender] += msg.value - overpaid;

        founder.transfer(this.balance);
        dgsToken.transfer(msg.sender, tokensToBeSent);

        if(overpaid != 0) {
            msg.sender.transfer(overpaid);
        }
    }

    function getLeftInvestmentAllowance(address _address)
    public constant returns (uint _leftInvestmentAllowance) {

        if(verified[_address]) {
          _leftInvestmentAllowance = tokensLeft * PRICE;
        } else {
            _leftInvestmentAllowance = SafeMath.min256(tokensLeft * PRICE,
              MAX_INVESTMENT - investedAmount[_address]);
        }
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
        offeringPaused = false;
        tokensLeft = dgsToken.balanceOf(this);
    }

    function pause() public onlyFounder() {
        offeringPaused = true;
    }

    function resume() public onlyFounder() {
        offeringPaused = false;
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
}
