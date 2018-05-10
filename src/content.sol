pragma solidity ^0.4.19;

import "./ownable.sol";

contract HdisContent {
    struct Content {
        uint type;
        string name;
    }

    Content[] content;
    mapping (string->uint) nameToContent;

    function AddContent(string _name, uint _type) public {
        uint id = content.push(Content(_name, _type)) - 1;
        nameToContent[_name] = id;
    }
}