// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasBurner {
    uint256 n;

    function burn() internal {
        while (gasleft() > 0) {
            n += 1;
        }
    }

    receive() external payable {
        burn();
    }
}