// SPDX-License-Identifier: GPL-3.0-or-later

// Copied from FEI protocol as I like how they use the Openzeppelin library
// and yet add some flexibility and a concrete series of example that allow me to adapt it: 
//  https://github.com/fei-protocol/fei-protocol-core/blob/develop/contracts/core/Permissions.sol

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./IPermissionsRead.sol";

/// @title Permissions interface
/// @author w31rdm4ch1nz
interface IPermissions is IAccessControl, IPermissionsRead {
    // ----------- Governor only state changing api -----------

    function createRole(bytes32 role, bytes32 adminRole) external;

    function grantMinter(address minter) external;

    function grantMember(address member) external;

    function grantFMProxy(address fmProxy) external;

    function grantGovernor(address governor) external;

    function grantGuardian(address guardian) external;

    function revokeMinter(address minter) external;

    function revokeMember(address member) external;

    function revokeFMProxy(address fmProxy) external;

    function revokeGovernor(address governor) external;

    function revokeGuardian(address guardian) external;

    // ----------- Revoker only state changing api -----------

    function revokeOverride(bytes32 role, address account) external;

    // ----------- Getters -----------

    function GUARDIAN_ROLE() external view returns (bytes32);

    function GOVERN_ROLE() external view returns (bytes32);

    function MEMBER_ROLE() external view returns (bytes32);

    function MINTER_ROLE() external view returns (bytes32);

    function FUNDS_MANAGER_ROLE() external view returns (bytes32);

}