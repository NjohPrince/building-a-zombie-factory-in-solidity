// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./zombieattack.sol";
import "./erc721.sol";

/**
 * @title Zombie Ownership Contract
 * @dev Demonstrate multiple inheritance concept
 */

contract ZombieOwnership is ZombieAttack, ERC721 {}
