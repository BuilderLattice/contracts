// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract BuilderDataSupplyMarket {
    struct User {
        address addr;
        string dataHash;  
    }
    struct Match {
        address fellowBuilder;
        uint compatibility;
    }

    mapping (address => User) public users;
    address[] public usersAddresses;
    uint public usersCount;

    mapping (address => Match[]) public matches;
    
    constructor() { }

    function editMatch(address user1, address user2, uint compatibility) public {
        matches[user1].push(Match(user2, compatibility));
        matches[user2].push(Match(user1, compatibility));
    }

    function createUser(string memory _dataHash) public {
        require(users[msg.sender].addr == address(0));
        User memory _user = User(msg.sender, _dataHash);
        users[msg.sender] = _user;
        usersAddresses.push(msg.sender);
        usersCount++;
    }

    function getUser(address _addr) public view returns (User memory) {
        require(users[_addr].addr != address(0), "User doesn't exist");
        return users[_addr];
    }

    function updateUserProfile(string memory _dataHash) public {
        require(users[msg.sender].addr == msg.sender, "You are not the owner of this profile");
        users[msg.sender].dataHash = _dataHash;
    }

    function getUsersCount() public view returns (uint) {
        return usersCount;
    }

    function getAllUsers() public view returns (User[] memory) {
        User[] memory usersArray = new User[](usersCount);
        for(uint i = 0; i < usersCount; i++) {
            usersArray[i] = users[usersAddresses[i]];
        } 
        return usersArray;
    }

    function getSelectedUsers(address[] memory _usersAddresses) public view returns (User[] memory) {
        uint length = _usersAddresses.length;
        User[] memory usersArray = new User[](length);
        for (uint i = 0; i < length; i++) {
            usersArray[i] = users[_usersAddresses[i]];
        }
        return usersArray;
    }

}
