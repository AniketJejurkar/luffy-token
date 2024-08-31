// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20Interface {
    function name() external view returns (string memory);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function getPriceOfOneLotOfTokenAndLotSize()
        external
        view
        returns (uint256, uint256);

    function balanceOf(address owner) external view returns (uint256);

    function transfer(
        address receipient,
        uint256 amount
    ) external returns (bool);

    function transferFrom(
        address sender,
        address receipient,
        uint256 amount
    ) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256 remaining);

    function getOwner() external view returns (address);

    function mint(uint256 amount) external returns (bool);

    function burn(uint256 amount) external returns (bool);

    function purchaseCoin() external payable returns (bool);
}
