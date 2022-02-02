// // SPDX-License-Identifier: MIT
// // Based on https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.1/contracts/utils/EnumerableSet.sol

// contract EnumerableSet {
//    struct bytes32Set {
//         Set _inner;
//     }

//     /**
//      * @dev Add a value to a set. O(1).
//      *
//      * Returns true if the value was added to the set, that is if it was not
//      * already present.
//      */
//     function add(bytes32Set storage set, bytes32 value) internal returns (bool) {
//         return _add(set._inner, value);
//     }

//     /**
//      * @dev Removes a value from a set. O(1).
//      *
//      * Returns true if the value was removed from the set, that is if it was
//      * present.
//      */
//     function remove(bytes32Set storage set, bytes32 value) internal returns (bool) {
//         return _remove(set._inner, value);
//     }

//     /**
//      * @dev Returns true if the value is in the set. O(1).
//      */
//     function contains(bytes32Set storage set, bytes32 value) internal view returns (bool) {
//         return _contains(set._inner, value);
//     }

//     /**
//      * @dev Returns the number of values in the set. O(1).
//      */
//     function length(bytes32Set storage set) internal view returns (uint256) {
//         return _length(set._inner);
//     }

//    /**
//     * @dev Returns the value stored at position `index` in the set. O(1).
//     *
//     * Note that there are no guarantees on the ordering of values inside the
//     * array, and it may change when more values are added or removed.
//     *
//     * Requirements:
//     *
//     * - `index` must be strictly less than {length}.
//     */
//     function at(bytes32Set storage set, uint256 index) internal view returns (bytes32) {
//         return _at(set._inner, index);
//     }
// }