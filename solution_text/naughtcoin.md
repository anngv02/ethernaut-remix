# NaughtCoin Challenge Solution

## Introduction

NaughtCoin is an ERC20 token contract where the player is given the total supply of tokens. However, the player is restricted from transferring these tokens for a period of 10 years due to a `lockTokens` modifier applied to the `transfer` function. The goal of this challenge is to bypass this restriction and reduce the player's token balance to zero.

## Target

The target is to bypass the `lockTokens` restriction and transfer all tokens from the player's account to another account, effectively reducing the player's balance to zero.

## Exploit Steps

### Step 1: Understand the Restriction
The `transfer` function in the `NaughtCoin` contract is overridden and protected by the `lockTokens` modifier. This modifier prevents the player (the initial token holder) from transferring tokens until the 10-year lock period has passed. However, the ERC20 standard provides other methods for transferring tokens, such as `transferFrom`, which is not restricted by the `lockTokens` modifier.

### Step 2: Use the Allowance Mechanism
The ERC20 standard includes an allowance mechanism that allows a token owner to authorize a spender to transfer tokens on their behalf. This mechanism is implemented using the `approve` and `transferFrom` functions.

1. **Approve a Spender**  
   The player can approve another account (referred to as the spender) to spend their tokens. This is done using the `approve` function.

   ```javascript
   await contract.approve(spender, totalBalance);
   ```

   Here, `totalBalance` is the player's total token balance, which can be obtained using the `balanceOf` function.

2. **Transfer Tokens Using `transferFrom`**  
   The spender can then use the `transferFrom` function to transfer the approved tokens from the player's account to any other account, including the spender's own account.

   ```solidity
   contract.transferFrom(player, spender, totalBalance);
   ```

### Step 3: Execute the Exploit
1. **Set Up Accounts**  
   - Ensure the player account is connected to the contract.
   - Create another account (spender) in your wallet.

2. **Approve the Spender**  
   Use the player's account to approve the spender for the total token balance.

   ```javascript
   totalBalance = await contract.balanceOf(player).then(v => v.toString());
   await contract.approve(spender, totalBalance);
   ```

3. **Transfer Tokens**  
   Switch to the spender account and use the `transferFrom` function to transfer all tokens from the player's account to the spender's account.

   ```solidity
   contract.transferFrom(player, spender, totalBalance);
   ```

   This can be done using a custom interface for the `NaughtCoin` contract:

   ```solidity
   // SPDX-License-Identifier: MIT
   pragma solidity ^0.6.0;

   interface INaughtCoin {
       function transferFrom(
           address sender,
           address recipient,
           uint256 amount
       ) external returns (bool);
   }
   ```

   Load the contract instance in Remix and call the `transferFrom` function with the appropriate parameters.

### Step 4: Verify the Result
After executing the exploit, check the player's balance to ensure it is zero:

```javascript
await contract.balanceOf(player).then(v => v.toString());
// Output: '0'
```

## Conclusion

The NaughtCoin challenge demonstrates the importance of understanding the full ERC20 specification when implementing token restrictions. By leveraging the `approve` and `transferFrom` functions, we successfully bypassed the `lockTokens` restriction and reduced the player's balance to zero. This highlights the need for comprehensive security measures when designing smart contracts.
