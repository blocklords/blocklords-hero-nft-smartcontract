// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Asset.sol";

contract HeroGame is Ownable, IERC721Receiver {
	ERC721 private nft;		   //Hero nft
	address private receiver;  //NFT default burning

	event ImportNft(address indexed user, uint256 nft1, uint256 nft2, uint256 nft3, uint256 nft4, uint256 nft5, uint256 indexed time);

	constructor(address _nft, address _receiver) {
		nft = ERC721(_nft);
		receiver = _receiver;
	}

	function importNft(bytes calldata data) external {
        (uint256[5] memory _nft) = abi.decode(data, (uint256[5]));

		for(uint i = 0; i < 5; i++){
			if(_nft[i] > 0){
				require(nft.ownerOf(_nft[i]) == msg.sender, "BlockLords Hero: Not hero owner");
				nft.safeTransferFrom(msg.sender, receiver, _nft[i]);
			}
		}
		emit ImportNft(msg.sender, _nft[0], _nft[1], _nft[2], _nft[3], _nft[4], block.timestamp);
	}

	function setReceiver(address _receiver) external onlyOwner{
		receiver = _receiver;
	}

    /// @dev encrypt token data
    /// @return encrypted data
    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}