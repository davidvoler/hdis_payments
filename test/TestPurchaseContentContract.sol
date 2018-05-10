pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";

import "../contracts/HdisContent.sol";

contract TestPurchaseContentContract {
    function testPurchaseContent() public {
        HdisContent hdisContent = HdisContent(DeployedAddresses.HdisContent());
        string memory name = "test";
        uint mediaId = 1;
        uint mediaType = 2;
        address creator = 0;
        uint price = 10 wei;

        uint id = hdisContent.addContent(name, mediaId, mediaType, creator, price);
        (mediaId, mediaType, creator, price) = hdisContent.getContentById(id);
        hdisContent.purchaseContent.value(0)(id);
    }

} 
