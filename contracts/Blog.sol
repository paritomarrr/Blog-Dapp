// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Blog {
    string public name;
    address public owner;

    using Counters for Counters.Counter;
    Counters.Counter private _postIds;

    struct Post {
        uint id;
        string title;
        string content;
        bool published;
    }

    // mappings can be seen as hash tables
    // here we create lookups for posts by id and posts by ipfs hash

    mapping(uint => Post) private idToPost;
    mapping(string => Post) private hashToPost;

    // events facilitates comm btw smart contrac and their user interfaces
    // we can create listeners for events in the client and also use them in the graph

    event PostCreated(uint id, string title, string hash);
    event PostUpdated(uint id, string title, string hash, bool published);

    // when the blog is deployed, give it a name
    // also set the creator as the owner of the contract

    constructor(string memory _name) {
        console.log("Deploying Blog with name", _name);
        name = _name;
        owner = msg.sender;
    }

    // updates the blog name
    function updateName(string memory _name) public {
        name = _name;
    }

    // transfers ownership of the contract to another address
    function transferOwnership(address newOwner) public {
        require(msg.sender == owner, "only the owner can transfer the ownership");
        owner = newOwner;
    }

    // fetches an individual post by the content hash
    function fetchPost (string memory hash) public view returns (Post memory) {
        return hashToPost[hash];
    }

    // creates a new post
    function createPost( string memory title, string memory hash) public {
        require(msg.sender == owner, "must be an owner");
        _postIds.increment();
        uint postId = _postIds.current();
        Post storage post = idToPost[postId];
        post.id = postId;
        post.published = true;
        post.content = hash;
        hashToPost[hash] = post;
        emit PostCreated(postId, title, hash);
    }


}
