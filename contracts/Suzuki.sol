// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Suzuki is ERC721, Ownable {
    
    using Counters for Counters.Counter;
    uint256 internal immutable mintTimestamp;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("Suzuki", "SZK") {
        mintTimestamp = block.timestamp;
    }

    uint256 public numberOfAddressAuthorized;

    mapping(address => bool) authorizedAddress;

    function safeMint(address to) public {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function AuthorizeUser(address _addressToBeAuthorized) public onlyOwner {
      require(!authorizedAddress[_addressToBeAuthorized], "Error: address already Authorized");
      authorizedAddress[_addressToBeAuthorized] = true;
      numberOfAddressAuthorized += 1;
    }

    function getAutorizedUserStatus(address _addressToBeAuthorized)public view returns(bool){
        return  authorizedAddress[_addressToBeAuthorized];
    }

    function getTimeStamp() public view returns(uint){
        return mintTimestamp;
    }


}