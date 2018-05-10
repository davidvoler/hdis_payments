pragma solidity ^0.4.19;

import "./ownable.sol";
import "./ownable.sol";
import "./ownable.sol";

contract HdisMediaFactory is HdisContentFactory {

    event PayForContent(contentId);

    


    function _useContent(contentId) internal {

    }
    function useContent(string _title, string mediaUrl, uint16 language,unit16 chapter,uint16 season) public {
      _useContent(_title, mediaUrl, language, chapter, season);
    }

    function _dividePayment(uint contentId, wei sum) internal returns (uint mediaSum, uint contentSum, uint infraSum){
      mediaSum = uint(sum/3);
      contentSum = uint(sum/3);
      infraSum = sum - (mediaSum + contentSum)
      return (mediaSum, contentSum, infraSum)
    } 
    function _payMedia(uint mediaId, wei sum) internal {
      //TODO
    }
    function _payInfra(wei sum) internal {
      //TODO
    }
    function _payContent(wei sum) internal {
      //TODO
    }
  
    function payMe(uint contentId, wei sum) internal {
      mediaId = _getMediaId(contentId);
      (mediaSum, contentSum,infraSum) = _dividePayment(contentId, sum);
      _payMedia(mediaId, mediaSum);
      _payContent(contentId, mediaSum);
      _payInfra(contentId, mediaSum);
    }
}