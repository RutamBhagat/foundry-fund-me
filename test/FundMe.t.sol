// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe s_fund_me;

    function setUp() external {
        s_fund_me = new DeployFundMe().run();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(s_fund_me.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(s_fund_me.I_OWNER(), address(msg.sender));
        // assertEq(s_fund_me.I_OWNER(), address(this));
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = s_fund_me.getVersion();
        assertEq(version, 4);
    }
}
