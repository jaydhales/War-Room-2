// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Puzzle} from "src/Puzz.sol";
import {SlotPuzzleFactory} from "src/PFactory.sol";
import {Param, Receivers} from "src/IFactory.sol";

import "../src/Attacker.sol";

contract CounterScript is Script {
    SlotPuzzleFactory public slotPuzzleFactory;

    function run() public {
        slotPuzzleFactory = SlotPuzzleFactory(0xe4468B70E70D06850Aea8387C1d13B81A0b2623C);
        vm.startBroadcast();

        // Attacker a = new Attacker(slotPuzzleFactory);
        // // address(a).call(abi.encodeWithSelector(a.attack.selector));

        // Attacker a = Attacker(0x5a2b221dd516362E6793A2A57f6f42D832CC48f8);

        // // address(a).call(abi.encodeWithSelector(a.attack.selector));
        // a.attack();

        console.log(address(slotPuzzleFactory).balance);
    }
}
