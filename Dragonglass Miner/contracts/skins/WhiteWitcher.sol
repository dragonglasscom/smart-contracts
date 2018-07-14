pragma solidity ^0.4.23;

import "../Skin.sol";

contract WhiteWitcher is Skin {

    string public name = "White Witcher";
    string public symbol = "DMWA";
    uint public decimals = 0;
    uint public INITIAL_SUPPLY = 1 * (10 ** decimals);

    constructor(string _assetUrl) public {
        skinRarity = Rarity.Legendary;
        assetUrl = _assetUrl;
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}
