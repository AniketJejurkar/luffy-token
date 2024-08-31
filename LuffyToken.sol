// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//imports
import "./ERC20Interface.sol";

//errors
error LuffyToken__Not_Sufficient_Sender_balance();
error LuffyToken__Not_Sufficient_Allowance_Amount();
error LuffyToken__NotOwner();
error LuffyToken__Not_Enough_Tokens_Available();

contract LuffyToken is ERC20Interface {
    //State Variables
    uint8 internal s_decimals = 18;
    address immutable i_owner;
    uint256 internal s_totalSupply = 1_000_000_000_000_000_000_000_000_000; //Total Tokens are 1_000_000_000
    uint256 internal priceOfOneLuffyTokenLotInWei = 1_000_000_000_000_000; //0.001 Eth
    uint256 internal numOfTokensInOneLot = 10;
    string internal s_symbol = "LUFFY";
    string internal s_name = "Luffy Token";
    mapping(address => uint256) internal s_balance;
    mapping(address => mapping(address => uint256)) internal allowances;

    //Events
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    //Modifiers
    modifier OnlyOwner() {
        if (msg.sender != i_owner) revert LuffyToken__NotOwner();
        _;
    }

    //Functions
    /*constructor*/
    constructor() {
        i_owner = msg.sender;
        s_balance[msg.sender] = s_totalSupply;
    }

    /*external*/
    function getPriceOfOneLotOfTokenAndLotSize()
        external
        view
        returns (uint256, uint256)
    {
        return (priceOfOneLuffyTokenLotInWei, numOfTokensInOneLot);
    }

    function getOwner() external view returns (address) {
        return i_owner;
    }

    function name() external view returns (string memory) {
        return s_name;
    }

    function decimals() external view returns (uint8) {
        return s_decimals;
    }

    function symbol() external view returns (string memory) {
        return s_symbol;
    }

    function totalSupply() external view returns (uint256) {
        return s_totalSupply;
    }

    function balanceOf(address owner) external view returns (uint256) {
        return s_balance[owner];
    }

    function transfer(
        address receipient,
        uint256 amount
    ) external returns (bool) {
        if (s_balance[msg.sender] < amount)
            revert LuffyToken__Not_Sufficient_Sender_balance();
        s_balance[msg.sender] -= amount;
        s_balance[receipient] += amount;
        emit Transfer(msg.sender, receipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address receipient,
        uint256 amount
    ) external returns (bool) {
        if (allowances[sender][receipient] < amount)
            revert LuffyToken__Not_Sufficient_Allowance_Amount();
        if (s_balance[sender] < amount)
            revert LuffyToken__Not_Sufficient_Sender_balance();
        allowances[sender][receipient] -= amount;
        s_balance[sender] -= amount;
        s_balance[receipient] += amount;
        emit Transfer(sender, receipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        if (s_balance[msg.sender] < amount)
            revert LuffyToken__Not_Sufficient_Sender_balance();
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256 remaining) {
        return allowances[owner][spender];
    }

    function mint(uint256 amount) external OnlyOwner returns (bool) {
        s_balance[i_owner] += amount;
        s_totalSupply += amount;
        return true;
    }

    function burn(uint256 amount) external OnlyOwner returns (bool) {
        s_balance[i_owner] -= amount;
        s_totalSupply -= amount;
        return true;
    }

    function purchaseCoin() public payable returns (bool) {
        uint256 payed = msg.value;
        uint256 tokenCnt = (numOfTokensInOneLot * payed) /
            priceOfOneLuffyTokenLotInWei;
        if (s_balance[i_owner] < tokenCnt)
            revert LuffyToken__Not_Enough_Tokens_Available();
        s_balance[msg.sender] += tokenCnt;
        s_balance[i_owner] -= tokenCnt;
        return true;
    }
}
