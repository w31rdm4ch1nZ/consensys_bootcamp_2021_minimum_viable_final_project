// SPDX-License-Identifier: GPL-3.0-or-later

// Copied from FEI protocol as I like how they use the Openzeppelin library
// and yet add some flexibility and a concrete series of example that allow me to adapt it: 
//  https://github.com/fei-protocol/fei-protocol-core/blob/develop/contracts/core/Permissions.sol

pragma solidity ^0.8.4;

/// @title Permissions Read interface
/// @author Fei Protocol
interface IPermissionsRead {
    // ----------- Getters -----------

    function isBurner(address _address) external view returns (bool);

    function isMinter(address _address) external view returns (bool);

    function isGovernor(address _address) external view returns (bool);

    function isGuardian(address _address) external view returns (bool);

    function isPCVController(address _address) external view returns (bool);
}