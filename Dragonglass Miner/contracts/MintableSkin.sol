pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol";
import "./access/roles/MinterRole.sol";

contract MintableSkin is StandardBurnableToken, MinterRole {

    event ChangeAssetUrl(string newAssetUrl);

    enum Rarity { Legendary, Epic, Rare, Common }

    string public assetUrl = "";
    Rarity public skinRarity = Rarity.Common;

    function changeAssetUrl(string newAssetUrl) public onlyMinter {
        assetUrl = newAssetUrl;
        emit ChangeAssetUrl(newAssetUrl);
    }

    function getAssetUrl() public view returns(string) {
        return assetUrl;
    }

    function getSkinRarity() public view returns(Rarity) {
        return skinRarity;
    }


    // ---------- Minting logic ----------
    bool public mintingFinished = false;

    modifier canMint() {
      require(!mintingFinished);
      _;
    }

    function mint(
      address _to,
      uint256 _amount
    )
      public
      onlyMinter
      canMint
      returns (bool)
    {
      totalSupply_ = totalSupply_.add(_amount);
      balances[_to] = balances[_to].add(_amount);
      emit Transfer(address(0), _to, _amount);
      return true;
    }

    function finishMinting() public onlyMinter canMint returns (bool) {
      mintingFinished = true;
      return true;
    }
}
