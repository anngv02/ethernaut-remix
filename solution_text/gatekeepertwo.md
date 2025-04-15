# Ethernaut Level 14: GatekeeperTwo

## Introduction

The GatekeeperTwo challenge is part of the Ethernaut series, designed to test your understanding of Solidity concepts such as `msg.sender`, `tx.origin`, `extcodesize`, and bitwise operations. The goal is to bypass three "gates" implemented in the contract to successfully call the `enter` function.

This walkthrough explains the mechanics of each gate and provides a step-by-step solution to exploit the contract.

---

## Target

The target contract requires you to pass three gates:

1. **Gate 1**: Ensure `msg.sender` is not equal to `tx.origin`.
2. **Gate 2**: Ensure the code size of the caller is zero.
3. **Gate 3**: Provide a `_gateKey` such that a specific bitwise XOR condition is satisfied.

---

## Exploit Steps

### Gate 1: Understanding `msg.sender` and `tx.origin`

- **Condition**: `msg.sender` must not equal `tx.origin`.
- **Explanation**: 
  - `msg.sender` is the address that directly called the function.
  - `tx.origin` is the address of the original external account that initiated the transaction.
  - To pass this gate, the call to `enter` must come from another contract, not directly from an externally owned account (EOA).

**Solution**: Deploy an attacking contract that calls the `enter` function on the target contract.

---

### Gate 2: The Mystery of Code Size

- **Condition**: The code size of the caller must be zero.
- **Explanation**:
  - The `extcodesize(address)` function returns the size of the code at a given address.
  - During contract deployment, the runtime bytecode is not yet stored on the blockchain. Therefore, the code size of the contract is zero during its constructor execution.

**Solution**: Call the `enter` function from within the constructor of the attacking contract.

---

### Gate 3: Bitwise XOR and Hashing

- **Condition**: The XOR of the hash of `msg.sender` (converted to `uint64`) and `_gateKey` must equal `uint64(0) - 1` (or `0xFFFFFFFFFFFFFFFF`).
- **Explanation**:
  - Compute the Keccak-256 hash of `msg.sender` using `keccak256(abi.encodePacked(msg.sender))`.
  - Convert the least significant 8 bytes of the hash to `bytes8`.
  - Cast `bytes8` to `uint64` and XOR it with `_gateKey`.
  - To satisfy the condition, `_gateKey` must be the bitwise complement of the hash of `msg.sender`.

**Solution**: Compute `_gateKey` in the constructor of the attacking contract as follows:
```solidity
bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);
```

---

## Implementation

Here is the attacking contract that exploits all three gates:

```solidity
// filepath: d:\ethernaut\ethernaut-remix\contracts\13_gatekeepertwo.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttack {
    IGatekeeperTwo public target;

    constructor(address targetAddress) {
        target = IGatekeeperTwo(targetAddress);
        
        // Compute gateKey to pass gateThree
        bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);

        // Call enter in the constructor
        target.enter(gateKey);
    }
}
```

---

## Conclusion

The GatekeeperTwo challenge demonstrates the importance of understanding Solidity's low-level mechanics, including `msg.sender`, `tx.origin`, `extcodesize`, and bitwise operations. By leveraging the unique behavior of contracts during deployment and carefully crafting the `_gateKey`, we successfully bypassed all three gates.

This challenge highlights the need for secure contract design and a deep understanding of Solidity to prevent unintended exploits.
