pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/HdisContent.sol";

contract TestAddContentContract is HdisContent {
    function testAddContent() public {
        HdisContent hdisContent = HdisContent(msg.sender);
        string memory name = "test";
        uint mediaId = 1;
        uint mediaType = 2;
        address creator = 0;
        uint price = 10 wei;
        address[] memory array;

        Content memory goldContent = Content({
            mediaId: mediaId,
            mediaType: mediaType,
            creator: creator,
            weiPrice: price,
            contributors: array
        });
        uint id = hdisContent.addContent(name, mediaId, mediaType, creator, price);
        (mediaId, mediaType, creator, price, array) = hdisContent.getContentById(id);
        Content memory createdContent = Content(mediaId, mediaType, creator, price, array);
        Assert.equal(createdContent.mediaId, goldContent.mediaId, "WTF");
        Assert.equal(createdContent.mediaType, goldContent.mediaType, "WTF");
    }

} 
