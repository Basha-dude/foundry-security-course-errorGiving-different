// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {StatelessFuzzCatches} from "../../src/invariant-break/StatelessFuzzCatches.sol";

import {Test} from "forge-std/Test.sol";

contract StatelessFuzzCatchesTest is Test {
    StatelessFuzzCatches sfc;

    function setUp() public {
        sfc = new StatelessFuzzCatches();
    }

    function testFuzzCatchesBugStateless(uint128 randomData) external view {
        require(sfc.doMath(randomData) != 0);
    }
}
