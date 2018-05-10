pragma solidity ^0.4.23;
pragma experimental ABIEncoderV2;

import "./ownable.sol";

contract HdisContent is Ownable {
    struct Content {
        uint mediaId;
        uint mediaType;
        address creator;
        uint weiPrice;
    }

    // This could be useful for a copyright watchtower
    event addContentEvent(Content indexed content);
    event purchaseContentEvent(Content indexed content, address buyer);

    mapping (uint => Content) private contents;
    mapping (address => uint[]) private purchase;

    function getContentById(uint _id) public view returns (Content) {
        return contents[_id];
    }

    function getContentByName(string _name, address _creator) public view returns (Content) {
        return getContentById(uint(keccak256(_name) ^ keccak256(_creator)));
    }

    function addContent(string _name, uint _mediaId, uint _mediaType, address _creator, uint _price) public onlyOwner returns (uint) {
        uint id = uint(keccak256(_name) ^ keccak256(_creator));
        Content memory _content = Content(_mediaId, _mediaType, _creator, _price);
        contents[id] = _content;
        emit addContentEvent(_content);
        return id;
    }

    // TODO: limit num of purchases to make
    // the array traversable in a reasonable time
    function purchaseContent(uint _contentId) public payable {
        uint fee = msg.value;
        Content memory content = contents[_contentId];
        require(fee >= content.weiPrice);
        address buyer = msg.sender;
        emit purchaseContentEvent(content, buyer);
    }
}
