pragma solidity ^0.4.23;

import "../Skin.sol";

contract SilverPickaxe is Skin {

    string public name = "Silver Pickaxe";
    string public symbol = "DMSA";
    uint public decimals = 0;
    uint public INITIAL_SUPPLY = 100 * (10 ** decimals);

    constructor(string _assetUrl) public {
        skinRarity = Rarity.Rare;
        assetUrl = _assetUrl;
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
    }
}
