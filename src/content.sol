pragma solidity ^0.4.19;

import "./ownable.sol";

contract HdisContent {
    struct Content {
        uint id;
        uint mediaId;
        uint contentType;
        string name;
        address owner;
    }

    Content[] content;
    mapping (string=>uint) nameToContent;

    function AddContent(uint _mediaId, uint _type, string _name) public {
        Content memory _content;
        uint _id = uint(keccak256(_name));
        _content = Content(_id, _mediaId, _type, _name, msg.sender);
        uint _idx = content.push(_content) - 1;
        nameToContent[_name] = _idx;
    }
}