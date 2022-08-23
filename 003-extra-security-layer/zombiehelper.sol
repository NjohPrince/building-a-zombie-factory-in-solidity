// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./zombiefeeding.sol";

/**
 * @title Zombie Helper
 * @dev Helper utilities to control our zombies abilities
 */

contract ZombieHelper is ZombieFeeding {
    // modifier to make sure our zombie is above a certain level
    modifier aboveLevel(uint256 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }
    
}
