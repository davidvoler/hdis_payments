pragma solidity ^0.4.23;

import "./SafeMath.sol";


/**
 * @title SplitPayment
 * @dev Base contract that supports multiple payees claiming funds sent to this contract
 * according to the proportion they own.
 */
contract SplitPayment {
  using SafeMath for uint256;

  uint256 public totalShares = 0;
  uint256 public totalReleased = 0;

  mapping(address => uint256) public shares;
  mapping(address => uint256) public released;
  address[] public payees;

  /**
   * @dev Constructor
   */
  constructor(address[] _payees, uint256[] _shares) public payable {
    require(_payees.length == _shares.length);

    for (uint256 i = 0; i < _payees.length; i++) {
      addPayee(_payees[i], _shares[i]);
    }
  }

  /**
   * @dev payable fallback
   */
  function () public payable {}

  /**
   * @dev Claim your share of the balance.
   */
  function claim() public {
    address payee = msg.sender;
    payTo(payee);
  }
    
  function payTo(address _payee) internal {
    require(shares[_payee] > 0);

    uint256 totalReceived = address(this).balance.add(totalReleased);
    uint256 payment = totalReceived.mul(shares[_payee]).div(totalShares).sub(released[_payee]);

    require(payment != 0);
    require(address(this).balance >= payment);

    released[_payee] = released[_payee].add(payment);
    totalReleased = totalReleased.add(payment);

    _payee.transfer(payment);
  }

  function distribute() internal {
    for (uint256 i = 0; i < payees.length; i++) {
      payTo(payees[i]);
    }
  }
  /**
   * @dev Add a new payee to the contract.
   * @param _payee The address of the payee to add.
   * @param _shares The number of shares owned by the payee.
   */
  function addPayee(address _payee, uint256 _shares) internal {
    require(_payee != address(0));
    require(_shares > 0);
    require(shares[_payee] == 0);

    payees.push(_payee);
    shares[_payee] = _shares;
    totalShares = totalShares.add(_shares);
  }
}
