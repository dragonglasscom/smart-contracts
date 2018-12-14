pragma solidity ^0.4.23;

import "../MintableSkin.sol";

contract Masquerade is MintableSkin {

    string public name = "Мasquerade";
    string public symbol = "DMMA";
    uint public decimals = 0;

    constructor(string _assetUrl) public {
        skinRarity = Rarity.Legendary;
        assetUrl = _assetUrl;
    }
}
