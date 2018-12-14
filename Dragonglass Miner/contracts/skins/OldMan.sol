pragma solidity ^0.4.23;

import "../MintableSkin.sol";

contract OldMan is MintableSkin {

    string public name = "OldMan";
    string public symbol = "DMOA";
    uint public decimals = 0;

    constructor(string _assetUrl) public {
        skinRarity = Rarity.Epic;
        assetUrl = _assetUrl;
    }
}
