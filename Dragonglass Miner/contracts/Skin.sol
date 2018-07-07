pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Skin is StandardBurnableToken, Ownable {

    event ChangeAssetUrl(string newAssetUrl);

    enum Rarity { Legendary, Epic, Rare, Common }

    string public assetUrl = "";
    Rarity public skinRarity = Rarity.Common;

    function changeAssetUrl(string newAssetUrl) public onlyOwner {
        assetUrl = newAssetUrl;
        emit ChangeAssetUrl(newAssetUrl);
    }

    function getAssetUrl() public view returns(string) {
        return assetUrl;
    }

    function getSkinRarity() public view returns(Rarity) {
        return skinRarity;
    }
}
