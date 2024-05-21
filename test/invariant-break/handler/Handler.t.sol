//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {HandlerStatefulFuzzCatches} from "../../../src/invariant-break/HandlerStatefulFuzzCatches.sol";
import {MockUSDC} from "../../mocks/MockUSDC.sol";
import {YeildERC20} from "../../mocks/YeildERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Handler is Test{
    HandlerStatefulFuzzCatches handlerStatefulFuzzCatches;
    YeildERC20 yeildERC20;
    MockUSDC mockUSDC;
    address user;

    constructor(HandlerStatefulFuzzCatches _handlerStatefulFuzzCatches,
    YeildERC20 _yeildERC20,
    MockUSDC _mockUSDC,
    address _user
    ) {
        handlerStatefulFuzzCatches = _handlerStatefulFuzzCatches;
        yeildERC20 =_yeildERC20;
        mockUSDC = _mockUSDC;
        user = _user;
    }

    function depositYeildERC20(uint256 _amount) public {
        uint256 amount = bound(_amount,0,yeildERC20.balanceOf(user));
        vm.startPrank(user);
        yeildERC20.approve(address(handlerStatefulFuzzCatches),amount);
        handlerStatefulFuzzCatches.depositToken(yeildERC20,amount);
        vm.stopPrank();
    }

     function depositMockUSDC(uint256 _amount) public {
        uint256 amount = bound(_amount,0,mockUSDC.balanceOf(user));
        vm.startPrank(user);
        mockUSDC.approve(address(handlerStatefulFuzzCatches),amount);
        handlerStatefulFuzzCatches.depositToken(mockUSDC,amount);
        vm.stopPrank();
    }
    function withdrawYeildERC20()  public {
                vm.startPrank(user);
          handlerStatefulFuzzCatches.withdrawToken(yeildERC20);
                vm.stopPrank();

    }

     function withdrawMockUSDC()  public {
                vm.startPrank(user);
          handlerStatefulFuzzCatches.withdrawToken(mockUSDC);
                vm.stopPrank();

    }



}


