// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./ownable.sol";

/**
 * @title Creating a Zombie Factory
 * @notice In this section we will create our zombie factory
 */

contract ZombieFactory is Ownable {
    // event to be emmitted when a zombie has been created
    event NewZombie(uint256 zombieId, string name, uint256 dna);

    // total number of digits that a zombie's DNA is to be composed of
    uint256 dnaDigits = 16;

    // will be used to convert our random number generated to 16 digits
    uint256 dnaModulus = 10**dnaDigits;

    // a zombie structure
    struct Zombie {
        string name;
        uint256 dna;
    }

    // an array of zombies made from or having the Zombie structure
    Zombie[] public zombies;

    // keeps track of the address that owns a zombie
    mapping(uint256 => address) public zombieToOwner;

    // keeps track of how many zombies an owner has
    mapping(address => uint256) ownerZombieCount;

    // internal function so that it can be accessed in derived functions
    function _createZombie(string memory _name, uint256 _dna) internal {
        zombies.push(Zombie(_name, _dna));
        uint256 id = zombies.length - 1;

        // assign zombie to an owner
        zombieToOwner[id] = msg.sender;

        // imcrement owner's zombie
        ownerZombieCount[msg.sender]++;

        // and fire it here
        emit NewZombie(id, _name, _dna);
    }

    // generates a 16 digit DNA value
    function _generateRandomDna(string memory _str)
        private
        view
        returns (uint256)
    {
        // generate a random uint
        uint256 rand = uint256(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }

    // this function helps us create a random zombie by calling or
    // making use of the function defined above
    function createRandomZombie(string memory _name) public {
        // limit every user to one zombie at first
        require(ownerZombieCount[msg.sender] == 0);

        // random dna generation
        uint256 randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}
