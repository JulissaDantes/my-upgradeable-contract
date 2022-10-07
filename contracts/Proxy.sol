pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/// @title Proxy for Loan-Platform to allow upgradeability
contract Proxy is OwnableUpgradeable {
    uint256 public interestRate;
    address public implementation;
    address public emergencyUpgrader;


    constructor(address _implemnatation, address _emergencyUpgrader) {
        implementation = _implemnatation;
        emergencyUpgrader = _emergencyUpgrader;
    }

    function upgrade(address _impl) external onlyOwner {
        implementation = _impl;
    }

    /**
     * @dev enable emergency upgrades from a different account than contract owner
     * @param _impl address of new implementation;
     */
    function emergencyUpgradeNrbc817539(address _impl) external {
        require(msg.sender == emergencyUpgrader, "You are not the emergency upgrader");
        implementation = _impl;
    }

    /**
    * @dev sets the daily interest rate
    * @param rate has 18 decimals
    * */
    function changeInterestRate(uint256 rate) external onlyOwner {
        interestRate = rate;
    }


    fallback() external payable {
       address impl = implementation;
       assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }



}