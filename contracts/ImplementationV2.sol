// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ImplementationV2 is Initializable {
  // these state variables and their values
  // will be preserved forever, regardless of upgrading
  uint x;
  uint public y;

  function initialize(uint _x, uint _y) public initializer {
    x = _x;
    y = _y;
  }
  
  function mult() public view returns(uint) {
    return x * y;
  }

  function newFunction() public view returns(uint) {
    return x + y;
  }
}