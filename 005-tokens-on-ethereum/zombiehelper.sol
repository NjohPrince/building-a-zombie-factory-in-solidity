// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./zombiefeeding.sol";

/**
 * @title Zombie Helper
 * @dev Helper utilities to control our zombies abilities
 */

contract ZombieHelper is ZombieFeeding {
    // fee for level up
    uint256 levelUpFee = 0.001 ether;

    // modifier to make sure our zombie is above a certain level
    modifier aboveLevel(uint32 _level, uint256 _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // function for the owner of the contract to withdraw from the contract
    // address(this).balance returns the amount of ethers paid to the contract's
    // address and will stay there unless we make a function or a way of
    // withdrawal
    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
    }

    // allow the owner to set the level up fee
    // as there is changes in the proce rate of
    // an ether and might be too expensive in
    // the future
    function setLevelUpFee(uint256 _fee) external onlyOwner {
        levelUpFee = _fee;
    }

    // function to level up zombies
    function levelUp(uint256 _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    // change zombie's name if level is >= 2
    function changeName(uint256 _zombieId, string calldata _newName)
        external
        aboveLevel(2, _zombieId)
        ownerOf(_zombieId)
    {
        // change the name of his/her zombie to a custom name
        zombies[_zombieId].name = _newName;
    }

    // change zombie's DNA if level is >= 20
    function changeDna(uint256 _zombieId, uint256 _newDna)
        external
        aboveLevel(20, _zombieId)
        ownerOf(_zombieId)
    {
        // change the DNA of his/her zombie to custom DNA
        zombies[_zombieId].dna = _newDna;
    }

    // get all zombies owned by a particular address
    // declaring our function as view and external
    // reduces the gas cost
    function getZombiesByOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        // array to hold the zombies belonging to the given address
        uint256[] memory result = new uint256[](ownerZombieCount[_owner]);

        uint256 counter = 0;
        for (uint256 i = 0; i < zombies.length; i++) {
            if (zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
}
