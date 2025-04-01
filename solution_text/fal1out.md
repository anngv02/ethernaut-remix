# Fallout Contract

## Contract Overview

The `Fallout` contract is intended to manage ETH allocations but contains a critical flaw due to a misnamed constructor function (`Fal1out` instead of `constructor`).

### Key Functions
- **`allocate()`**: Allows users to send ETH, which is stored in their allocations.
- **`sendAllocation()`**: Transfers the allocated ETH back to the user.
- **`collectAllocations()`**: Enables the owner to withdraw all ETH from the contract.

## Security Vulnerability

The `Fal1out` function is not recognized as a constructor because of the naming error. This allows **anyone** to call it and claim ownership of the contract.

### Exploit Steps
1. An attacker calls the `Fal1out` function to become the owner.
2. The attacker uses `collectAllocations()` to drain all ETH from the contract.

### Constructor Declaration Error
In the `Fallout` contract, the intended constructor is incorrectly named `Fal1out` instead of `Fallout` or `constructor`.

- In Solidity version 0.6.0, using the contract name as a constructor was deprecated. The `constructor` keyword must be used instead.
- Due to the incorrect name, `Fal1out` is treated as a regular public function instead of a constructor.

### Ownership Takeover Exploit
By calling 
```javascript 
await contract.Fal1out()
``` 
from the console or a script, the `Fal1out` function executes as a normal function. This sets `owner` to `msg.sender` (the caller), allowing anyone who calls this function to become the owner of the contract.

### Ownership Verification
After calling `await contract.Fal1out()`, ownership can be verified with:

```javascript
await contract.owner() === player
```

If the output is `true`, it confirms that the `player` has become the contract owner. Complete!!!

### Summary
This is a critical yet simple mistake: an incorrectly named constructor allows anyone to take control of the contract. Since Solidity v0.5.0, the `constructor` keyword is mandatory, preventing this error in newer versions.
