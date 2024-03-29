// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Puzzle} from "src/Puzz.sol";
import {SlotPuzzleFactory} from "src/PFactory.sol";
import {Param, Receivers} from "src/IFactory.sol";

contract Attacker {
    Receivers private _receiver;
    address public attacker;
    SlotPuzzleFactory public slotPuzzleFactory;

    constructor(SlotPuzzleFactory s_) {
        attacker = tx.origin;
        _receiver = Receivers(attacker, address(s_).balance / 3);

        slotPuzzleFactory = s_;
    }

    function attack() public {
        bytes32 sKey = calculateSlotKey();
        Receivers[] memory _receivers = new Receivers[](3);
        _receivers[0] = _receiver;
        _receivers[1] = _receiver;
        _receivers[2] = _receiver;

        Param memory param = Param(3, 452, _receivers, abi.encode(sKey, uint256(0x124)));

        slotPuzzleFactory.deploy(param);
    }

    function calculateSlotKey() public view returns (bytes32 k_) {
        unchecked {
            // hashInfo[tx.origin][block.number
            bytes32 firstSlot =
                bytes32(uint256(keccak256(abi.encode(block.number, keccak256(abi.encode(attacker, uint256(1)))))) + 1);

            // ....map[block.timestamp][msg.sender]
            bytes32 secondSlot = bytes32(
                uint256(
                    keccak256(abi.encode(address(slotPuzzleFactory), keccak256(abi.encode(block.timestamp, firstSlot))))
                ) + 1
            );

            // ....map[block.prevrandao][block.coinbase]
            bytes32 thirdSlot = bytes32(
                uint256(keccak256(abi.encode(block.coinbase, keccak256(abi.encode(block.prevrandao, secondSlot))))) + 1
            );

            // ....map[block.chainid]
            bytes32 fourthSlot = keccak256(abi.encode(block.chainid, thirdSlot));

            // ...[address(uint160(uint256(blockhash(block.number - block.basefee))))]
            k_ = keccak256(
                abi.encode(
                    keccak256(
                        abi.encode(address(uint160(uint256(blockhash(block.number - block.basefee)))), fourthSlot)
                    )
                )
            );
        }
    }
}
