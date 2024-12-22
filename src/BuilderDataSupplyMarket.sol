// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title BuilderDataSupplyMarket.
 * @author BuilderLattice.
 * @notice Contract that stores hash and compatibility of builders.
 */

contract BuilderDataSupplyMarket {
    /// @notice Struct to store a user's address and hash corrosponding to its data.
    struct User {
        address userAddress;
        string userHash;
    }
    /// @notice Struct depecting compatibility between users.
    struct Match {
        address userAddress;
        uint256 compatibilityConstant;
    }

    /// @notice Array of users.
    User[] public usersArray;

    /// @notice Mapping from user address to user struct.
    mapping(address => User) public users;
    /// Mapping from a user to the array of users it is compatible with.
    mapping(address => Match[]) public matches;

    constructor() {}

    /**
     * @notice Edits the compatibility between two users.
     * @param user1 Address of the first user.
     * @param user2 Address of the second user.
     * @param compatibility Compatibility between them.
     */
    function editMatch(
        address user1,
        address user2,
        uint compatibility
    ) public {
        matches[user1].push(Match(user2, compatibility));
        matches[user2].push(Match(user1, compatibility));
    }

    /**
     * @notice Creates a new user in this contract.
     * @param _dataHash Hash of the data for the user.
     */
    function createUser(string memory _dataHash) public {
        require(users[msg.sender].userAddress == address(0));
        User memory _user = User(msg.sender, _dataHash);
        users[msg.sender] = _user;
        usersArray.push(_user);
    }

    /**
     * @notice Updates data hash for a user(msg.sender).
     * @param _dataHash Hash of the data for the user.
     */
    function updateDataHash(string memory _dataHash) public {
        require(
            users[msg.sender].userAddress == msg.sender,
            "You are not the owner of this profile"
        );
        users[msg.sender].userHash = _dataHash;
    }

    function exportCompatibilityData() public payable returns (bytes memory) {}

    /**
     * @notice Returns a user struct.
     * @param _addr Address of the user.
     */
    function getUser(address _addr) public view returns (User memory) {
        require(users[_addr].userAddress != address(0), "User doesn't exist");
        return users[_addr];
    }

    /**
     * @notice Returns an array of all users.
     */
    function getAllUsers() public view returns (User[] memory) {
        return usersArray;
    }

    /**
     * @notice Returns an array of selected users.
     * @param _usersAddresses Addresses of the users as an array.
     */
    function getSelectedUsers(
        address[] memory _usersAddresses
    ) public view returns (User[] memory) {
        uint length = _usersAddresses.length;
        User[] memory arr = new User[](length);
        for (uint i = 0; i < length; i++) {
            arr[i] = users[_usersAddresses[i]];
        }
        return arr;
    }
}
