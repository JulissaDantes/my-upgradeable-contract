// contracts/Box.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
contract TBox {
    uint256 private value;
    type MyUserValueType is uint128;
    MyUserValueType my_user_value;
    // Emitted when the stored value changes
    event ValueChanged(uint256 newValue);

    function foo(MyUserValueType v) external {
       my_user_value = v;
    }
 
    // Stores a new value in the contract
    function store(uint256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }
 
    // Reads the last stored value
    function retrieve() public view returns (uint256) {
        return value;
    }
}