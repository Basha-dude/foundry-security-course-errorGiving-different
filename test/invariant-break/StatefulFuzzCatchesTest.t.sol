// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {StatefulFuzzCatches} from "../../src/invariant-break/StatefulFuzzCatches.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

contract StatefulFuzzCatchesTest is StdInvariant, Test {
    StatefulFuzzCatches statefulFuzzCatches;

    function setUp() public {
        statefulFuzzCatches = new StatefulFuzzCatches();
        targetContract(address(statefulFuzzCatches));
    }

    function testdoIt(uint128 myNumber) external {
        assert(statefulFuzzCatches.doMoreMathAgain(myNumber) != 0);
    }

    function statefulFuzz_testdoIt() public view {
        assert(statefulFuzzCatches.storedValue() != 0);
    }
}
