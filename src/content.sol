pragma solidity ^0.4.23;

import "./ownable.sol";

contract HdisContent is Ownable {
    struct Content {
        uint id;
        uint mediaId;
        uint mediaType;
        string name;
        string owner;
    }

    event addContentEvent(Content indexed content);

    mapping (uint=>Content) contents;

    function addContent(uint _mediaId, uint _mediaType, string _name, string _owner) public onlyOwner returns (uint) {
        uint _id = uint(keccak256(_name) ^ keccak256(_owner));
        Content memory _content = Content(_id, _mediaId, _mediaType, _name, _owner);
        contents[_id] = _content;
        emit addContentEvent(_content);
        return _id;
    }
}