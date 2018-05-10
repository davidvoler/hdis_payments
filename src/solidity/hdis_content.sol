pragma solidity ^0.4.19;

import "./ownable.sol";

contract HdisContent is Ownable {

    event NewHdisContent(uint contentId, string title, string contentUrl, uint mediaId, uint16 language,unit16 studentLanguage, uint16 level);

    struct HdisContent {
      string title;
      address contentOwner;
      string contentUrl;
      uint mediaId;
      uint16 language;
      uint16 studentLanguage;
      uint16 level;
    }

    HdisContent[] public contents;

    mapping (uint => address) public contentToOwner;
    mapping (address => uint) ownerContentCount;

    function _createContent(string _title, string _contentUrl, uint _mediaId, uint16 _language, unit16 _studentLnguage, uint16 _level) internal {
        uint contentId = contents.push(HdisContent( _title, _contentUrl, _mediaId, _language, _studentLnguage, _level)) - 1;
        contentToOwner[contentId] = msg.sender;
        ownerContentCount[msg.sender]++;
        NewHdisContent(contentId, _contentUrl, _mediaId, _language, _studentLnguage, _level);
    }
    function createHdisContent(string _title, string _contentUrl, uint _mediaId, uint16 _language, unit16 _studentLnguage, uint16 _level) public {
      _createContent(_title, _contentUrl, _mediaId, _language, _studentLnguage, _level);
    }

}