pragma solidity ^0.4.11;

// ERC20 interface
contract ERC20Interface {

    // Get total token supply
    function totalSupply()
    public constant returns (uint256 _totalSupply);

    // Get specific account balance
    function balanceOf(address _owner)
    public constant returns (uint256 balance);

    // Send _value tokens to the address _to
    function transfer(address _to, uint256 _value)
    public returns (bool success);

    // Send _value of tokens from address one address to another (withdraw)
    function transferFrom(address _from, address _to, uint256 _value)
    public returns (bool success);

    // Allow _spender to withdraw from sender account _value times
    function approve(address _spender, uint256 _value)
    public returns (bool success);

    // Get the amount which _spender is allowed to withdraw from _owner
    function allowance(address _owner, address _spender)
    public constant returns (uint256 remaining);

    // Triggered when tokens are transferred.
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    // Triggered whenever approve(...) is called.
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
