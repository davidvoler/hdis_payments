pragma solidity ^0.4.23;

import "./ownable.sol";
import "./SplitPayment.sol";

contract HdisContent is Ownable {  
    using SafeMath for uint256;
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

    mapping (uint256 => uint256) public totalShares;
    mapping (uint256 => uint256) public totalReleased;
    mapping(uint256 => mapping(address => uint256)) public shares;
    mapping(uint256 => mapping(address => uint256)) public released;
    mapping(uint256 => address[]) public payees;

    /**
     * @dev Constructor
     */
    constructor() Ownable() public payable {
    }

    /**
     * @dev payable fallback
     */
    function () public payable {}

    /**
     * @dev Claim your share of the balance.
     */
    function claim(uint _content) public {
        address payee = msg.sender;
        payTo(_content, payee);
    }

    function payTo(uint _content, address _payee) internal {
        require(shares[_content][_payee] > 0);

        uint256 totalReceived = address(this).balance.add(totalReleased[_content]);
        uint256 payment = totalReceived.mul(shares[_content][_payee]).div(totalShares[_content]).sub(released[_content][_payee]);

        require(payment != 0);
        require(address(this).balance >= payment);

        released[_content][_payee] = released[_content][_payee].add(payment);
        totalReleased[_content] = totalReleased[_content].add(payment);

        _payee.transfer(payment);
    }

    function distribute(uint _content) internal {
        for (uint256 i = 0; i < payees[_content].length; i++) {
            payTo(_content, payees[_content][i]);
        }
    }
    /**
    * @dev Add a new payee to the contract.
    * @param _payee The address of the payee to add.
        * @param _shares The number of shares owned by the payee.
        */
    function addPayee(uint _content, address _payee, uint256 _shares) internal {
        require(_payee != address(0));
        require(_shares > 0);
        require(shares[_content][_payee] == 0);

        payees[_content].push(_payee);
        addShares(_content, _payee, _shares);
    }

    function addShares(uint _content, address _payee, uint256 _shares) internal {
        shares[_content][_payee] = _shares;
        totalShares[_content] = totalShares[_content].add(_shares);
    }

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
        address[] memory emptyArray;
        Content memory _content = Content(_mediaId, _mediaType, _creator, _price, emptyArray);
        contents[id] = _content;
        contentIds.push(id);
        emit addContentEvent(_content);
        return id;
    }

    function addContributor(uint _id, address _contributor) public onlyOwner {
        contents[_id].contributors.push(_contributor);
        if(shares[_id][_contributor] == 0) {
            addPayee(_id, _contributor, 1);
        }
        else {
            addShares(_id, _contributor, 1);
        }
    }

    // TODO: limit num of purchases to make
    // the array traversable in a reasonable time
    function purchaseContent(uint _contentId) public payable {
        uint fee = msg.value;
        Content memory content = contents[_contentId];
        require(fee >= content.weiPrice);
        address buyer = msg.sender;
        purchases[buyer].push(_contentId);
        emit purchaseContentEvent(content, buyer);
        distribute(_contentId);
    }


}
