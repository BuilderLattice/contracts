// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/**
 * @title BuilderDataSupplyMarket.
 * @author BuilderLattice.
 * @notice Contract that stores hash and compatibility of builders.
 */
contract BuilderLattice {
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

    uint256 constant PREMIUM_FEE = 0.001 ether;
    /// @notice Array of users.
    User[] internal usersArray;

    /// @notice Mapping from user address to user struct.
    mapping(address => User) internal users;
    /// Mapping from a user to the array of users it is compatible with.
    mapping(address => Match[]) public matches;
    /// Mapping indicating if the user has paid the premium for exporting data.
    mapping(address => bool) public hasPaid;

    constructor() {}

    /**
     * @notice Edits the compatibility and match between two users, unit transaction, not as an array.
     * @param user1 Address of the first user.
     * @param user2 Address of the second user.
     * @param compatibility Compatibility between them.
     */
    function editMatch(
        address user1,
        address user2,
        uint256 compatibility
    ) public {
        matches[user1].push(Match(user2, compatibility));
        matches[user2].push(Match(user1, compatibility));
    }

    /**
     * @notice Updates the matches of an user, taking in an array of match addresses.
     * @param _user Address of the user.
     * @param _matches Array of match addresses.
     */
    function editMatchAsArray(address _user, address[] memory _matches) public {
        for (uint256 i = 0; i < _matches.length; i++) {
            editMatch(_user, _matches[i], 5);
        }
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

    /**
     * @notice Pay the premium for exporting data.
     */
    function payPremiumForExport() public payable {
        require(msg.value >= PREMIUM_FEE, "Not enough funds");
        hasPaid[msg.sender] = true;
    }

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
     * @notice Caller must have called payPremiumForExport or should have an existing profile
     * before calling this function.
     */
    function getAllUsers() public view returns (User[] memory) {
        require(
            (hasPaid[msg.sender] == true) ||
                (users[msg.sender].userAddress == msg.sender),
            "Not paid yet or no profile yet."
        );
        return usersArray;
    }

    /**
     * @notice Returns an array of selected users.
     * @param _usersAddresses Addresses of the users as an array.
     */
    function getSelectedUsers(
        address[] memory _usersAddresses
    ) public view returns (User[] memory) {
        uint256 length = _usersAddresses.length;
        User[] memory arr = new User[](length);
        for (uint256 i = 0; i < length; i++) {
            arr[i] = users[_usersAddresses[i]];
        }
        return arr;
    }

    /**
     * @notice Returns an array of matches for a user.
     * @param _user Address of the user.
     */
    function getUserMatches(
        address _user
    ) public view returns (Match[] memory) {
        return matches[_user];
    }
}
