// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract ImplementationV4 is Initializable {
  // these state variables and their values
  // will be preserved forever, regardless of upgrading
  uint x;
  uint public y;

  struct Juli {
    uint8 status;
    uint16 newVal;//Trying to check the storage of gap
    string mood;
  }

  struct MyStruct {
        uint16 val1;
        uint16 val2;
        uint64 val3;
        uint160 val4;
        string name;
  }

  Juli public juli;
  MyStruct public mystruct;

  struct SafeBox {
        bool done;
        function(uint, bytes12) internal callback;
        bytes12 hash;
        uint value;
  }
  SafeBox box;
  function initialize(uint _x, uint _y) public initializer {
    juli = Juli(0, 2, "fun");
    x = _x;
    y = _y;
  }
  
  function mult() public view returns(uint) {
    return x * y;
  }

  function newFunction() public view returns(uint) {
    return x + y;
  }

  function getJuli() public view returns (uint8, string memory) {
    return (juli.status, juli.mood);
  }

  function changeJuli(uint8 status, uint16 newVal, string memory mood) public {
    juli = Juli(status, newVal, mood);
  }
}