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
    // instead of hardcoding the address of the kitty contract
    // address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;

    // we make it dynamic
    // so incase the address changes or something happens to the contract
    // we could switch unto another contract
    KittyInterface kittyContract;

    // to make sure the current sender owns the zombie
    modifier onlyOwnerOf(uint256 _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        _;
    }

    // this function is made external --implying other contracts have access to this
    // we want only the contract owner to be able to set the kitties address
    // so we will restrict this only to calls made by the contract's owner address
    function setKittyContractAddress(address _address) external onlyOwner {
        kittyContract = KittyInterface(_address);
    }

    // trigger cooldown time of a zombie --making the game more interesting
    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(block.timestamp + cooldownTime);
    }

    // check if the zombie is ready
    function _isReady(Zombie storage _zombie) internal view returns (bool) {
        return (_zombie.readyTime <= block.timestamp);
    }

    function feedAndMultiply(
        uint256 _zombieId,
        uint256 _targetDna,
        string memory _species
    ) internal onlyOwnerOf(_zombieId) {
        // get that zombie from our storage
        Zombie storage myZombie = zombies[_zombieId];

        // check if the zombie is ready to be fed
        // the user will be able to run this only when the zombie is ready
        _isReady(myZombie);

        // make sure we have 16 digits for the targeDna
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

        // default zombies name to NoName initially
        // we will fix this later on
        _createZombie("NoName", newDna);

        // trigger cool down
        _triggerCooldown(myZombie);
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
