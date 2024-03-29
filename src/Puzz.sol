// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "./IFactory.sol";

// Objective of CTF

//Your purpose is to recover the 3 ether.

contract Puzzle {
    bytes32 public immutable hash = 0x68747470733a2f2f6769746875622e636f6d2f61726176696e64686b6d111111;
    IFactory public factory;

    struct hashStore {
        bytes32[] hash;
        mapping(uint256 => mapping(address => hashStore)) map;
    }

    mapping(address => mapping(uint256 => hashStore)) private hashInfo;

    error InvalidSlot();

    constructor() {
        hashInfo[tx.origin][block.number].map[block.timestamp][msg.sender].map[block.prevrandao][block.coinbase].map[block
            .chainid][address(uint160(uint256(blockhash(block.number - block.basefee))))].hash.push(hash);

        factory = IFactory(msg.sender);
    }

    function determineSlot(Param calldata params) external returns (bool status) {
        require(address(factory) == msg.sender);
        require(params.receivers.length == params.totalReceivers);

        bytes memory slotKey = params.slotKey;
        bytes32 slot;
        uint256 offset = params.offset;

        assembly {
            offset := calldataload(offset)
            slot := calldataload(add(slotKey, offset))
        }

        getValue(slot, hash);

        for (uint8 i = 0; i < params.receivers.length; i++) {
            factory.payout(params.receivers[i].account, params.receivers[i].amount);
        }

        return true;
    }

    function getValue(bytes32 slot, bytes32 validResult) internal view {
        bool validOffsets;
        assembly {
            validOffsets := eq(sload(slot), validResult)
        }

        if (!validOffsets) {
            revert InvalidSlot();
        }
    }

    function gethashGit() public pure returns (string memory) {
        return string(abi.encodePacked(hash));
    }
}
