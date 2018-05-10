pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "./ownable.sol";

contract HdisContent is Ownable {
    struct Content {
        uint id;
        uint mediaId;
        uint mediaType;
        address creator;
    }

    event addContentEvent(Content indexed content);

    mapping (uint => Content) private contents;

    function getContent(uint _id) public view returns (Content) {
        return contents[_id];
    }

    function addContent(uint _mediaId, uint _mediaType, address _creator) public onlyOwner returns (uint) {
        uint _id = uint(keccak256(_creator));
        Content memory _content = Content(_id, _mediaId, _mediaType, _creator);
        contents[_id] = _content;
        emit addContentEvent(_content);
        return _id;
    }
}
