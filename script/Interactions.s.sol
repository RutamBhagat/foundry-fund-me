// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract FundingFundMe is Script {
    uint256 SEND_VALUE = 0.1 ether;

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        fundingFundMeFunc(mostRecentlyDeployed);
    }

    function fundingFundMeFunc(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funding FundMe with %s", SEND_VALUE);
    }
}

contract WithDrawingFundMe is Script {
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
        withDrawingFundMeFunc(mostRecentlyDeployed);
    }

    function withDrawingFundMeFunc(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).cheaperWithdraw();
        vm.stopBroadcast();
        console.log("Withdrawing funds from fundMe contract %s", mostRecentlyDeployed.balance);
    }
}
