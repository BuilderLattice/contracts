// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BuilderLattice} from "../src/BuilderLattice.sol";

contract Deploy is Script {
    BuilderLattice public bl;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        bl = new BuilderLattice();
        console.log(address(bl));

        vm.stopBroadcast();
    }
}
