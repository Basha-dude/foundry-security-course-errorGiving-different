// SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {YeildERC20} from "../../mocks/YeildERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Handler} from "./Handler.t.sol";

contract Invariant is StdInvariant, Test {
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    MockUSDC mockUSDC;
    YeildERC20 yeildERC20;
    IERC20[] supposedTokens;
    uint256 startingAmount;
    address user = makeAddr("user");
    Handler handler;

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
           
           handler = new Handler(handlerStatefulFuzzCatches,yeildERC20,mockUSDC,user); 

            bytes4[] memory selectors = new bytes4[](4);
             selectors[0] = handler.depositYeildERC20.selector; 
             selectors[1] = handler.depositMockUSDC.selector;
             selectors[2] = handler.withdrawMockUSDC.selector;
            selectors[3]  = handler.withdrawYeildERC20.selector; 
             targetSelector(FuzzSelector({addr : address(handler),selectors:selectors }));  

    }

     function statefulFuzz_testInvariantsBreakHandler() public {
        vm.startPrank(user);
        handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
        handlerStatefulFuzzCatches.withdrawToken(yeildERC20);
        vm.stopPrank();
                   
          assert(mockUSDC.balanceOf(address(handlerStatefulFuzzCatches)) == 0);
        assert(yeildERC20.balanceOf(address(handlerStatefulFuzzCatches)) == 0);

        assert(yeildERC20.balanceOf(user) == startingAmount);
        assert(mockUSDC.balanceOf(user) == startingAmount);
        
    }

}
