// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./zombieattack.sol";
import "./erc721.sol";

/**
 * @title Zombie Ownership Contract
 * @dev Demonstrate multiple inheritance concept
 */

abstract contract ZombieOwnership is ZombieAttack, ERC721 {
    function balanceOf(address _owner)
        external
        view
        override
        returns (uint256)
    {
        return ownerZombieCount[_owner];
    }

    function ownerOf(uint256 _tokenId)
        external
        view
        override
        returns (address)
    {
        return zombieToOwner[_tokenId];
    }

    // transfer ownership of your zombie
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerZombieCount[_to]++;
        ownerZombieCount[_from]--;
        zombieToOwner[_tokenId] = _to;
        emit Transfer(_from, _to, _tokenId);
      }

    // function transferFrom(
    //     address _from,
    //     address _to,
    //     uint256 _tokenId
    // ) external payable {}

    // function approve(address _approved, uint256 _tokenId) external payable {}
}
