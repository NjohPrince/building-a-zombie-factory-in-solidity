// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title Zoombie Feeding Module
 */

import "./zombiefactory.sol";

// making use of a kitty interface which resides on the blockchain
// to get crypto kitties which we will use to feed our kities.
interface KittyInterface {
    function getKitty(uint256 _id)
        external
        view
        returns (
            bool isGestating,
            bool isReady,
            uint256 cooldownIndex,
            uint256 nextActionAt,
            uint256 siringWithId,
            uint256 birthTime,
            uint256 matronId,
            uint256 sireId,
            uint256 generation,
            uint256 genes
        );
}

contract ZombieFeeding is ZombieFactory {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    KittyInterface kittyContract = KittyInterface(ckAddress);

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;

        // zombie's new DNA is gotten from the average
        uint256 newDna = (myZombie.dna + _targetDna) / 2;

        // store 99 at the last two digits of our zombie's DNA
        // to make them have kitty characeristics
        if (
            keccak256(abi.encodePacked(_species)) ==
            keccak256(abi.encodePacked("kitty"))
        ) {
            newDna = newDna - (newDna % 100) + 99;
        }
        _createZombie("NoName", newDna);
    }

    // function to feed on kitty
    function feedOnKitty(uint256 _zombieId, uint256 _kittyId) public {
        uint256 kittyDna;

        // we are only interested in the genes returned from our interface
        (, , , , , , , , , kittyDna) = kittyContract.getKitty(_kittyId);

        // feed on the kitty and multiply
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }
}
