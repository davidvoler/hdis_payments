pragma solidity ^0.4.19;

import "./ownable.sol";

contract HdisMediaFactory is Ownable {

    event NewHdisMedia(uint mediaId, string _title, string mediaUrl, uint16 language,unit16 chapter,uint16 season);

    struct HdisMedia {
      string title;
      address mediaOwner;
      string mediaUrl;
      uint16 language;
      unit16 chapter;
      uint16 season;
    }

    HdisMedia[] public medias;

    mapping (uint => address) public mediaToOwner;
    mapping (address => uint) ownerMediaCount;

    function _createMedia(string _title, string mediaUrl, uint16 language,unit16 chapter,uint16 season) internal {
        uint mediaId = medias.push(HdisMedia(_title, mediaUrl, language, chapter,season)) - 1;
        mediaToOwner[mediaId] = msg.sender;
        ownerMediaCount[msg.sender]++;
        NewZombie(mediaId, _title, mediaUrl, language, chapter,season);
    }
    function createHdisMedia(string _title, string mediaUrl, uint16 language,unit16 chapter,uint16 season) public {
      _createMedia(_title, mediaUrl, language, chapter, season);
    }

}