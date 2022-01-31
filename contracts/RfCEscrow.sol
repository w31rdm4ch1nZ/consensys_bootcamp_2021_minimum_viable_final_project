// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract RfCEscrow {


    // function depositERC721(
    //     address tokenAddress,
    //     uint256 tokenId,
    //     uint256 bundleId
    // ) external override {
    //     require(_exists(bundleId), "Bundle does not exist");

    //     IERC721(tokenAddress).safeTransferFrom(_msgSender(), address(this), tokenId);

    //     bundleERC721Holdings[bundleId].push(ERC721Holding(tokenAddress, tokenId));
    //     emit DepositERC721(_msgSender(), bundleId, tokenAddress, tokenId);
    // }


    // function depositERC1155(
    //     address tokenAddress,
    //     uint256 tokenId,
    //     uint256 amount,
    //     uint256 bundleId
    // ) external override {
    //     require(_exists(bundleId), "Bundle does not exist");

    //     IERC1155(tokenAddress).safeTransferFrom(_msgSender(), address(this), tokenId, amount, "");

    //     bundleERC1155Holdings[bundleId].push(ERC1155Holding(tokenAddress, tokenId, amount));
    //     emit DepositERC1155(_msgSender(), bundleId, tokenAddress, tokenId, amount);
    // }




}