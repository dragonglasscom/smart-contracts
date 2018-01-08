pragma solidity ^0.4.11;

import "./ERC20Interface.sol";
import "./SafeMath.sol";

contract DGS is ERC20Interface {

    string public constant name = "Dragonglass";
    string public constant symbol = "DGS";
    uint public constant decimals = 8;

    // Total tokens supply
    uint256 supply = 70;
    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    // How many tokens address can mine during the ICO
    mapping (address => uint) allowedToMineDuringICO;

    // Address of ICO contract
    address public allocationAddressICO;

    // Amount of tokens avalable for mining
    uint256 public minableSupplly = 0;

    // Founder addresses
    address founder1;
    address founder2;

    uint public newPeriodTargetTime = 0;

    // Period legth in days
    uint private constant periodLentgh = 30;
    uint private constant miningPeriodsMax = 11;
    uint private miningPeriodsPassed = 0;

    enum State {
        Sleeping,
        ICOMining,
        InitialMining,
        WaitingForPeriodMining,
        PeriodMining
    }

    // Curent State
    State public state;

    function DGS (uint256 _initial,
        address _founder1,
        address _founder2
        ) public {
            supply = _initial;
            minableSupplly = supply * 10;
            founder1 = _founder1;
            founder2 = _founder2;
            state = State.Sleeping;
    }

    modifier onlyFounder {
        require(msg.sender == founder1 ||
            msg.sender == founder2);
        _;
    }

    // Get total token supply
    function totalSupply()
    public constant returns (uint256 _totalSupply) {
        _totalSupply = supply;
    }

    // Get specific account balance
    function balanceOf(address _owner)
    public constant returns (uint256 balance) {
        return balances[_owner];
    }

    function getCurrentState()
    public constant returns (State _state) {
        _state = state;
    }

    // Get available for mining supply
    function getMinableSupply()
    public constant returns (uint256 _minableSupply){
        _minableSupply = minableSupplly;
    }

    // Get next mining period date
    function getTargetPeriodDate()
    public constant returns (uint _date) {
        _date = newPeriodTargetTime;
    }

    // Send _value tokens to the address _to
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

    // Send _value of tokens from address one address to another (withdraw)
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

    // Allow _spender to withdraw from sender account _value times
    function approve(address _spender, uint256 _value)
    public returns (bool success){
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    // Get the amount which _spender is allowed to withdraw from _owner
    function allowance(address _owner, address _spender)
    public constant returns (uint256 remaining){
        return  allowed[_owner][_spender];
    }

    // Set ICO contract address
    function setIcoAddress(address _icoAddress) public onlyFounder() {
        require(allocationAddressICO == address(0));
        allocationAddressICO = _icoAddress;
        balances[allocationAddressICO] = totalSupply();
    }

    function mine
    (address _sender, address _receiver, uint _transactionValue) private {
        if(state == State.ICOMining) {
            if(_sender == allocationAddressICO) {
                // Allow to mine x10
                allowedToMineDuringICO[_receiver] += _transactionValue * 10;
            } else {
                doIcoMining(_sender, _transactionValue);
            }
        }
        else if(state == State.InitialMining) {
            doMining(_sender, _transactionValue);
        }
        else if(state == State.PeriodMining) {
            doMining(_sender, _transactionValue);
        }
        else if(state == State.WaitingForPeriodMining) {
            checkPeriod(_sender, _transactionValue);
        }
        else if(state == State.Sleeping) {
            require(allocationAddressICO != address(0));
            state = State.ICOMining;

            if(_sender == allocationAddressICO) {
                // Allow to mine x10
                allowedToMineDuringICO[_receiver] += _transactionValue * 10;
            } else {
                doIcoMining(_sender, _transactionValue);
            }
        }
    }

    function doIcoMining(address _miner, uint _transactionValue)
    private {
        uint _minedAmount = miner(_miner, _transactionValue);
        if(allowedToMineDuringICO[_miner] <= _minedAmount) {
            _minedAmount = allowedToMineDuringICO[_miner];
            allowedToMineDuringICO[_miner] = 0;
        } else {
            allowedToMineDuringICO[_miner] -= _minedAmount;
        }
        balances[_miner] += _minedAmount;
        supply += _minedAmount;
        Mined(_miner, _minedAmount);
    }

    function doMining(address _miner, uint _transactionValue)
    private {
        uint _tokensToBeMined = miner(_miner, _transactionValue);

        if(_tokensToBeMined >= minableSupplly) {
            balances[_miner] += minableSupplly;
            supply += minableSupplly;
            Mined(_miner, minableSupplly);
            minableSupplly = 0;
            stageExpired();
            return;
        }

        minableSupplly -= _tokensToBeMined;
        balances[_miner] += _tokensToBeMined;
        supply += _tokensToBeMined;
        Mined(_miner, _tokensToBeMined);
    }

    // Returns amount of mined coins
    function miner(address _miner, uint _value)
    public returns (uint _minedAmount) {

        uint stake = balanceOf(_miner);
        uint decimalIndex = 10**decimals;
        uint minLimit = 1 * decimalIndex/10;
        uint maxLimit = 16785 * decimalIndex/100000;
        uint stakeIndex = 70;

        var _max = SafeMath.max256(_value, stake);
        var _min = SafeMath.min256(_value, stake);

        uint factor = (minLimit + (_min * decimalIndex/_max)* (maxLimit-minLimit) / decimalIndex);
        _minedAmount = (factor + stake*stakeIndex/100) *_value/decimalIndex;
    }

    // Called after minale supply is expired
    function stageExpired() private {
        miningPeriodsPassed += 1;
        newPeriodTargetTime = block.timestamp + periodLentgh * 1 days;
        state = State.WaitingForPeriodMining;
    }

    function checkPeriod(address _miner, uint256 _value) private {
        require(block.timestamp >= newPeriodTargetTime);
        require(miningPeriodsPassed <= miningPeriodsMax);
        state = State.PeriodMining;
        setMinableSupply();
        doMining(_miner, _value);
    }

    function setMinableSupply() private {
        minableSupplly += 11111100000000;
    }

    // Called by ICO contract when ICO is over
    function icoFinished() public {
        require(msg.sender == allocationAddressICO);
        state = State.Sleeping;
    }

    event Mined(address indexed _miner, uint256 _minedAmount);
}
