// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title ERC721 Token Contract
 * @dev Demonstrate multiple inheritance concept
 */

abstract contract ERC721 {
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );

    function balanceOf(address _owner) external view virtual returns (uint256);

    function ownerOf(uint256 _tokenId) external view virtual returns (address);

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable virtual;

    function approve(address _approved, uint256 _tokenId)
        external
        payable
        virtual;
}
