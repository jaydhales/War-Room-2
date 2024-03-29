// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/test.sol";

import {Puzzle} from "src/Puzz.sol";
import {SlotPuzzleFactory} from "src/PFactory.sol";
import {Param, Receivers} from "src/IFactory.sol";

import "../src/Attacker.sol";

contract PuzzleTest is Test {
    //  Puzzle public puzzle;
    SlotPuzzleFactory public slotPuzzleFactory;
    address hacker;

    function setUp() public {
        slotPuzzleFactory = new SlotPuzzleFactory{value: 3 ether}();

        hacker = makeAddr("hacker");
    }

    function testG() public {
        vm.startPrank(hacker, hacker);
        Attacker a = new Attacker(slotPuzzleFactory);
        a.attack();

        vm.assertEq(address(slotPuzzleFactory).balance, 0);
        vm.assertEq(hacker.balance, 3 ether);
    }
}
