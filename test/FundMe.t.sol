// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe s_fund_me;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        s_fund_me = new DeployFundMe().run();
        vm.deal(USER, STARTING_BALANCE);
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

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert(bytes("Funding amount must be at least 5 USD of ETH"));
        s_fund_me.fund{value: 0}();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        s_fund_me.fund{value: SEND_VALUE}();
        uint256 amountFunded = s_fund_me.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}
