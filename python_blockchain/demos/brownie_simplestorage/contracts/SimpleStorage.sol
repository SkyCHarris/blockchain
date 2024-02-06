// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {

    // sets favoriteNumber variable equal to 0
    uint256 favoriteNumber;

    // object for people w/ fav number
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    // dynamic array, can be added to
    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public returns(uint256) {    // pass type, then parameter, then 'public'
        favoriteNumber = _favoriteNumber;
        return _favoriteNumber;
    }

    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}