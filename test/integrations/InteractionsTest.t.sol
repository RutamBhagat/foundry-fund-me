// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundingFundMe, WithDrawingFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe s_fund_me;
    address public constant USER = address(1);
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_USER_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        s_fund_me = deployer.run();
        vm.deal(USER, STARTING_USER_BALANCE);
    }

    function testUserCanFundInteractions() public {
        FundingFundMe fundingFundMe = new FundingFundMe();
        fundingFundMe.fundingFundMeFunc(address(s_fund_me));

        WithDrawingFundMe withdrawingFundMe = new WithDrawingFundMe();
        withdrawingFundMe.withDrawingFundMeFunc(address(s_fund_me));

        assertEq(address(s_fund_me).balance, 0);
    }
}
