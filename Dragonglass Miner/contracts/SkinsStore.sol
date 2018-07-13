pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract SkinsStore is Ownable {
    using SafeMath for uint256;

    event NewTokenPlaced(string tokenSymbol);
    event Sell(string tokenSymbol, uint amount);

    enum Currency { DGS, ETH }

    struct TokenForSale {
        address token;
        Currency currency;
        uint price;
        uint amount;
    }

    ERC20 public dgsToken;

    mapping(string => TokenForSale) tokensForSale;

    constructor(address dgsTokenAddress) public {
        dgsToken = ERC20(dgsTokenAddress);
    }

    function placeNewToken(
        string symbol,
        address tokenAddress,
        Currency currency,
        uint price,
        uint amount
        )
        public
        onlyOwner
    {
        require(tokensForSale[symbol].amount == 0);
        require(ERC20(tokenAddress).balanceOf(address(this)) >= amount);

        TokenForSale memory token = TokenForSale(
            tokenAddress,
            currency,
            price,
            amount
            );

        tokensForSale[symbol] = token;

        emit NewTokenPlaced(symbol);
    }

    function buyTokenForEth(string symbol, uint amount, address receiver)
    public payable returns (bool success) {
        TokenForSale storage token = tokensForSale[symbol];
        require(amount <= token.amount);
        require(token.currency == Currency.ETH);
        require(amount <= msg.value / token.price);

        token.amount -= amount;

        owner.transfer(address(this).balance);
        ERC20(token.token).transfer(receiver, amount);

        emit Sell(symbol, amount);
        return true;

    }

    function buyTokenForDgs(string symbol, uint amount, address receiver)
    public returns (bool success)
    {
        TokenForSale storage token = tokensForSale[symbol];
        require(amount <= token.amount);
        require(token.currency == Currency.DGS);
        require(dgsToken.allowance(
            msg.sender, address(this)) >= amount * token.price);

        token.amount -= amount;

        dgsToken.transferFrom(msg.sender, owner, amount * token.price);
        ERC20(token.token).transfer(receiver, amount);

        emit Sell(symbol, amount);
        return true;
    }

    function getTokenForSell(string symbol)
    public
    view
    returns (address token, Currency currency, uint price, uint amount) {
        return (
            tokensForSale[symbol].token,
            tokensForSale[symbol].currency,
            tokensForSale[symbol].price,
            tokensForSale[symbol].amount
            );
    }

    function getTokenForSaleData(string symbol)
    public
    view
    returns (Currency currency, uint price, uint amount) {
        return (
            tokensForSale[symbol].currency,
            tokensForSale[symbol].price,
            tokensForSale[symbol].amount
            );
    }

    function getTokenForSaleAddress(string symbol)
    public
    view
    returns (address tokenAddress) {
        return tokensForSale[symbol].token;
    }
}
