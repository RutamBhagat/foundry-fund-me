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
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        s_fund_me = new DeployFundMe().run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(s_fund_me.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(s_fund_me.getOwner(), address(msg.sender));
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

    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        s_fund_me.fund{value: SEND_VALUE}();
        address funder = s_fund_me.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        s_fund_me.fund{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnerCanWithDraw() public funded {
        vm.expectRevert();
        s_fund_me.withdraw();
    }

    function testWithDrawWithASingleFunder() public funded {
        uint256 startingOwnerBalance = s_fund_me.getOwner().balance;
        uint256 startingFundMeBalance = address(s_fund_me).balance;

        vm.prank(s_fund_me.getOwner());
        s_fund_me.withdraw();

        uint256 endingOwnerBalance = s_fund_me.getOwner().balance;
        uint256 endingFundMeBalance = address(s_fund_me).balance;

        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
        assertEq(endingFundMeBalance, 0);
    }

    function testWithDrawFromMultipleFunders() public funded {
        // Funding step
        uint160 numberOfFunders = 1000;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            s_fund_me.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = s_fund_me.getOwner().balance;
        uint256 startingFundMeBalance = address(s_fund_me).balance;

        //// use this only if you want to simulate gas transactions
        // uint256 gasStart = gasleft();
        // vm.txGasPrice(GAS_PRICE);
        vm.startPrank(s_fund_me.getOwner());
        s_fund_me.withdraw();
        vm.stopPrank();
        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log(gasUsed);

        uint256 endingOwnerBalance = s_fund_me.getOwner().balance;
        uint256 endingFundMeBalance = address(s_fund_me).balance;

        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
        assertEq(endingFundMeBalance, 0);
    }

    function testWithDrawFromMultipleFundersCheaper() public funded {
        // Funding step
        uint160 numberOfFunders = 1000;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            s_fund_me.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = s_fund_me.getOwner().balance;
        uint256 startingFundMeBalance = address(s_fund_me).balance;

        //// use this only if you want to simulate gas transactions
        // uint256 gasStart = gasleft();
        // vm.txGasPrice(GAS_PRICE);
        vm.startPrank(s_fund_me.getOwner());
        s_fund_me.cheaperWithdraw();
        vm.stopPrank();
        // uint256 gasEnd = gasleft();
        // uint256 gasUsed = (gasStart - gasEnd) * tx.gasprice;
        // console.log(gasUsed);

        uint256 endingOwnerBalance = s_fund_me.getOwner().balance;
        uint256 endingFundMeBalance = address(s_fund_me).balance;

        assertEq(startingOwnerBalance + startingFundMeBalance, endingOwnerBalance);
        assertEq(endingFundMeBalance, 0);
    }
}
