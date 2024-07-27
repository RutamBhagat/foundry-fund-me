// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundingFundMe, WithDrawingFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe s_fund_me;

    function setUp() external {
        DeployFundMe deployer = new DeployFundMe();
        s_fund_me = deployer.run();
    }

    function testUserCanFundInteractions() public {
        FundingFundMe fundingFundMe = new FundingFundMe();
        fundingFundMe.fundingFundMeFunc(address(s_fund_me));

        WithDrawingFundMe withdrawingFundMe = new WithDrawingFundMe();
        withdrawingFundMe.withDrawingFundMeFunc(address(s_fund_me));

        assertEq(address(s_fund_me).balance, 0);
    }
}
