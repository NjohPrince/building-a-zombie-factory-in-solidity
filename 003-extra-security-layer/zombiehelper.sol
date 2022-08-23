// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./zombiefeeding.sol";

/**
 * @title Zombie Helper
 * @dev Helper utilities to control our zombies abilities
 */

contract ZombieHelper is ZombieFeeding {
    // modifier to make sure our zombie is above a certain level
    modifier aboveLevel(uint32 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // change zombie's name if level is >= 2
    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
    {
        // make sure that the current caller is the owner of the zombie
        require(msg.sender == zombieToOwner[_zombieId]);

        // change the name of his/her zombie to a custom name
        zombies[_zombieId].name = _newName;
    }

    // change zombie's DNA if level is >= 20
    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
    {
        // make sure that the current caller is the owner of the zombie
        require(msg.sender == zombieToOwner[_zombieId]);

        // change the DNA of his/her zombie to custom DNA
        zombies[_zombieId].dna = _newDna;
    }
}
