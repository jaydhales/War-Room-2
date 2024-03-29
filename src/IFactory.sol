// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

struct Receivers {
    address account;
    uint256 amount;
}

struct Param {
    uint256 totalReceivers;
    uint256 offset;
    Receivers[] receivers;
    bytes slotKey;
}

interface IFactory {
    function payout(address wallet, uint256 amount) external;
    function determineSlot(Param calldata params) external returns (bool status);
}
