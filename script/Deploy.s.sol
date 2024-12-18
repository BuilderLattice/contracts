// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BuilderDataSupplyMarket} from "../src/BuilderDataSupplyMarket.sol";

contract Deploy is Script {
    BuilderDataSupplyMarket public bdsm;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        bdsm = new BuilderDataSupplyMarket();
        console.log(address(bdsm));

        vm.stopBroadcast();
    }
}
