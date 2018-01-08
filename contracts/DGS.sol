pragma solidity ^0.4.18;

import "./ERC20Interface.sol";
import "./SafeMath.sol";

contract DGS is ERC20Interface {

    string public constant name = "Dragonglass";
    string public constant symbol = "DGS";
    uint public constant decimals = 8;

    uint256 supply = 0;
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    mapping (address => uint) allowedToMine;

    address public allocationAddressICO;

    uint256 public mineableSupply = 0;

    address founder;

    // Miner constants
    uint public constant decimalIndex = 10**decimals;

    //Represents constant 0,25892541
    uint private constant miningPercentage = 25892541 * decimalIndex / (10**8);
    uint private constant stakeIndex = 5;

    function DGS (uint256 _initial,
        address _founder) public {
            supply = _initial;
            mineableSupply = supply * 10;
            founder = _founder;
    }

    modifier onlyFounder {
        require(msg.sender == founder);
        _;
    }

    function totalSupply()
    public constant returns (uint256 _totalSupply) {
        _totalSupply = supply;
    }

    function balanceOf(address _owner)
    public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function getAllowedToMine(address _owner)
    public constant returns (uint _allowedToMine) {
        return allowedToMine[_owner];
    }

    // Get available for mining supply
    function getMineableSupply()
    public constant returns (uint256 _mineableSupply){
        _mineableSupply = mineableSupply;
    }

    function transfer(address _to, uint256 _value)
    public returns (bool success) {
        require(_to != address(0));
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        mine(msg.sender, _to, _value);
        balances[_to] += _value;
        Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool success) {
        uint256 allowance = allowed[_from][msg.sender];
        require(_to != address(0) && balances[_from] >= _value
            && allowance >= _value);
            balances[_from] -= _value;
            mine(_from, _to, _value);
            balances[_to] += _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
    }

    function approve(address _spender, uint256 _value)
    public returns (bool success){
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
    public constant returns (uint256 remaining){
        return  allowed[_owner][_spender];
    }

    function setIcoAddress(address _icoAddress) public onlyFounder() {
        require(allocationAddressICO == address(0));
        allocationAddressICO = _icoAddress;
        balances[allocationAddressICO] = totalSupply();
    }

    function mine
    (address _sender, address _receiver, uint _transactionValue) private {
        if(_sender == allocationAddressICO) {
            // Allow to mine x10
            allowedToMine[_receiver] += _transactionValue * 10;
        } else {
            doMining(_sender, _transactionValue);
        }
    }

    function doMining(address _miner, uint _transactionValue)
    private {
        uint _minedAmount = calculteMinedCoinsForTX(_miner, _transactionValue);
        if(allowedToMine[_miner] <= _minedAmount) {
            _minedAmount = allowedToMine[_miner];
            allowedToMine[_miner] = 0;
        } else {
            allowedToMine[_miner] -= _minedAmount;
        }
        balances[_miner] += _minedAmount;
        supply += _minedAmount;
        mineableSupply -= _minedAmount;
        Mined(_miner, _minedAmount);
    }

    function calculteMinedCoinsForTX(address _miner, uint _value)
    public returns (uint _minedAmount) {

        uint stake = balanceOf(_miner) - _value;

        var _max = SafeMath.max256(_value, stake);
        var _min = SafeMath.min256(_value, stake);

        uint factor = _min * decimalIndex /_max * miningPercentage / decimalIndex;

        if(_value > stake)
            factor += stakeIndex * decimalIndex / 100;
        if(factor > miningPercentage)
            factor = miningPercentage;
        _minedAmount = (stake + _value) * factor / decimalIndex;
    }

    function setmineableSupply() private {
        mineableSupply += 111111 * decimalIndex;
    }

    event Mined(address indexed _miner, uint256 _minedAmount);
}
