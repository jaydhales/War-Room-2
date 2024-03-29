// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {ReentrancyGuard} from "openzeppelin-contracts/security/ReentrancyGuard.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {Puzzle} from "./Puzz.sol";
import {EnumerableSet} from "openzeppelin-contracts/utils/structs/EnumerableSet.sol";
import "./IFactory.sol";

contract SlotPuzzleFactory is ReentrancyGuard {
    using EnumerableSet for EnumerableSet.AddressSet;
    using SafeTransferLib for address;

    EnumerableSet.AddressSet deployedAddress;

    constructor() payable {
        require(msg.value == 3 ether);
    }

    function deploy(Param calldata params) external nonReentrant {
        Puzzle newContract = new Puzzle();

        deployedAddress.add(address(newContract));
        newContract.determineSlot(params);
    }

    function payout(address wallet, uint256 amount) external {
        require(deployedAddress.contains(msg.sender));
        require(amount == 1 ether);
        wallet.safeTransferETH(amount);
    }
}
