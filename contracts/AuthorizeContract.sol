// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./Suzuki.sol";
import "./MyToken.sol";

contract AuthorizeContract is Ownable, ERC721Holder {
    using SafeERC20 for IERC20;

    Suzuki public suzukiNFT;
    MyToken public myToken;

    constructor(address _suzuki, address _myToken){
        suzukiNFT = Suzuki(_suzuki);
        myToken = MyToken(_myToken);
    }

    function balanceOf( address _address) external view returns(uint){
        uint balance = myToken.balanceOf(_address);
        return balance;
    }

    function BuyNft(IERC20 _Token) public  {
        uint256 tokenAmount = calculateTokenAmount();
        require(_Token.balanceOf(msg.sender) > tokenAmount, "Not enough Token in your wallet");
        require(suzukiNFT.getAutorizedUserStatus(msg.sender) ==  true, "Not Authorized User");
        _Token.safeTransferFrom(msg.sender, address(this), tokenAmount);
        suzukiNFT.safeMint(msg.sender);
    } 

    function calculateTokenAmount() public view returns(uint) {
        uint256 _mintTimestamp = suzukiNFT.getTimeStamp();
        uint256 interval = (block.timestamp - _mintTimestamp) / 2 days;
        uint256 intervalAmount = (interval * 50) + 100;
        return intervalAmount;
    }   
}