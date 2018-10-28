pragma solidity ^0.4.23;

import "../Skin.sol";

contract JackPumkinhead is Skin {

    string public name = "Jack Pumkinhead";
    string public symbol = "DMJA";
    uint public decimals = 0;
    uint public INITIAL_SUPPLY = 30 * (10 ** decimals);

    constructor(string _assetUrl) public {
        skinRarity = Rarity.Epic;
        assetUrl = _assetUrl;
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}
