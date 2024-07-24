// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address public immutable i_owner;
    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate() >= MINIMUM_USD,
            "Funding amount must be at least 5 USD of ETH"
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Withdrawal failed");
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }
}
