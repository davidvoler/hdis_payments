pragma solidity ^0.4.23;

import "./ownable.sol";

contract HdisContent is Ownable {
    struct Content {
        uint mediaId;
        uint mediaType;
        address creator;
        uint weiPrice;
        address[] contributors;
    }

    // This could be useful for a copyright watchtower
    event addContentEvent(Content indexed content);
    event purchaseContentEvent(Content indexed content, address buyer);

    mapping (uint => Content) private contents;
    uint[] private contentIds;
    mapping (address => uint[]) private purchases;

    function generateId(string _name, address _creator) private pure
    returns (uint) {
        return uint(keccak256(_name) ^ keccak256(_creator));
    }

    function getContentById(uint _id) public view
    returns (uint, uint, address, uint, address[]) {
        Content memory content = contents[_id];
        return (content.mediaId, content.mediaType, content.creator, content.weiPrice, content.contributors);
    }

    function getContentByName(string _name, address _creator) public view
    returns (uint, uint, address, uint, address[]) {
        return getContentById(generateId(_name, _creator));
    }

    function getContentIds() public view returns (uint[]) {
        return contentIds;
    }

    function addContent(string _name, uint _mediaId, uint _mediaType, address _creator, uint _price) public
    returns (uint) {
        uint id = generateId(_name, _creator);
        address[] memory empty_array;
        Content memory _content = Content(_mediaId, _mediaType, _creator, _price, empty_array);
        contents[id] = _content;
        contentIds.push(id);
        emit addContentEvent(_content);
        return id;
    }

    function addContributor(uint _id, address _contributor) public onlyOwner {
        contents[_id].contributors.push(_contributor);
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
