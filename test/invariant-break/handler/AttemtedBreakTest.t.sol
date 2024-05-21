// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {YeildERC20} from "../../mocks/YeildERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AttemtedBreakTest is StdInvariant, Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    MockUSDC mockUSDC;
    YeildERC20 yeildERC20;
    IERC20[] supposedTokens;
    uint256 startingAmount;
    address user = makeAddr("user");

    function setUp() external {
        vm.startPrank(user);
        yeildERC20 = new YeildERC20();
        mockUSDC = new MockUSDC();
        startingAmount = yeildERC20.INITIAL_SUPPLY();
        mockUSDC.mint(user, startingAmount);
        vm.stopPrank();
        supposedTokens.push(mockUSDC);
        supposedTokens.push(yeildERC20);
        handlerStatefulFuzzCatches = new HandlerStatefulFuzzCatches(supposedTokens);
        targetContract(address(handlerStatefulFuzzCatches));
    }

    function testStartingAmountIsTheSame() public view {
        assert(startingAmount == yeildERC20.balanceOf(user));
        assert(startingAmount == mockUSDC.balanceOf(user));

        console.log(startingAmount, "staring balance");
        console.log(yeildERC20.balanceOf(user), " yeildERC20.balanceOf(user)");
        console.log(mockUSDC.balanceOf(user), " mockUSDC.balanceOf(user)");
    }

    function statefulFuzz_testInvariantsBreak() public {
        vm.startPrank(user);
        handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
        handlerStatefulFuzzCatches.withdrawToken(yeildERC20);

        assert(yeildERC20.balanceOf(user) == startingAmount);
        assert(mockUSDC.balanceOf(user) == startingAmount);
        assert(mockUSDC.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
        assert(yeildERC20.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
    }
}
