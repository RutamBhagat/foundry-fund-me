// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;
    address private immutable I_OWNER;
    address[] private s_funders;
    mapping(address funder => uint256 amountFunded) private s_address_to_amount_funded;
    AggregatorV3Interface private s_price_feed;

    constructor(address price_feed) {
        I_OWNER = msg.sender;
        s_price_feed = AggregatorV3Interface(price_feed);
    }

    function fund() public payable {
        require(
            msg.value.getConversionRate(s_price_feed) >= MINIMUM_USD, "Funding amount must be at least 5 USD of ETH"
        );
        s_funders.push(msg.sender);
        s_address_to_amount_funded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 i = 0; i < s_funders.length; i++) {
            address funder = s_funders[i];
            s_address_to_amount_funded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdrawal failed");
    }

    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            s_address_to_amount_funded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdrawal failed");
    }

    modifier onlyOwner() {
        if (msg.sender != I_OWNER) {
            revert FundMe__NotOwner();
        }
        _;
    }

    function getVersion() public view returns (uint256) {
        return s_price_feed.version();
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_address_to_amount_funded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return I_OWNER;
    }
}
