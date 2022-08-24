// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./zombiehelper.sol";

/**
 * @title Zombie Attack COnfigurations
 */

contract ZombieAttack is ZombieHelper {
    uint256 randNonce = 0;
    uint256 attackVictoryProbability = 70;

    function randMod(uint256 _modulus) internal returns (uint256) {
        randNonce++;
        return
            uint256(keccak256(abi.encodePacked(now, msg.sender, randNonce))) %
            _modulus;
    }

    // attack function
    function attack(uint256 _zombieId, uint256 _targetId) external {}
}
