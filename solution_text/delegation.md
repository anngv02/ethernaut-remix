## Knowledge

`delegatecall` is a low-level function in Solidity that allows a contract (the Caller) to execute code from another contract (the Callee) while maintaining the storage, `msg.sender`, and value of the Caller. 

In simpler terms, `delegatecall` executes the logic of the Callee contract but applies any state changes to the Caller's storage. This makes it a powerful tool for building upgradeable and modular smart contracts, enabling code reuse and supporting proxy patterns for upgrading contract logic without changing the contract address.

Unlike the `call` function, `delegatecall` does not switch the execution context to the target contract. Instead, it retains the context of the Caller, allowing access to its storage and state.

However, using `delegatecall` requires careful implementation to avoid security risks, such as unexpected state changes or reentrancy attacks. It is critical that both the Caller and Callee contracts share the same storage layout to prevent unpredictable behavior.

## Introduction

The `Delegation` contract demonstrates a vulnerability related to the improper use of `delegatecall`. This challenge is designed to teach developers about the risks of using `delegatecall` without proper access control.

## Target

The goal is to exploit the `Delegation` contract and take ownership by leveraging the `delegatecall` mechanism in the fallback function.

## Context

The `Delegation` contract uses a `Delegate` contract to handle certain logic via `delegatecall`. The fallback function in `Delegation` forwards any call data to the `Delegate` contract using `delegatecall`. However, `delegatecall` executes the code of the `Delegate` contract in the context of the `Delegation` contract, allowing the state of `Delegation` to be modified.

## Security Vulnerability

The vulnerability lies in the use of `delegatecall` in the fallback function without proper access control. An attacker can craft a malicious call to invoke the `pwn` function in the `Delegate` contract, which modifies the `owner` variable of the `Delegation` contract. This allows the attacker to take ownership of the `Delegation` contract, bypassing any intended security mechanisms.

## Exploit Steps

Follow these steps to exploit the `Delegation` contract and take ownership:

1. **Create the Payload**  
   Open the developer tools in your browser (press `F12`) and create a data payload for the `pwn()` function using the following command:
   ```javascript
   const payload = web3.utils.keccak256("pwn()");
   ```

2. **Send the Payload**  
   Send the payload to the fallback function of the `Delegation` contract using a transaction:
   ```javascript
   await contract.sendTransaction({data: payload});
   ```

3. **Verify Ownership**  
   Check if you are now the owner of the `Delegation` contract by running the following command:
   ```javascript
   (await contract.owner()) === player;
   ```
   If the result is `true`, you have successfully exploited the contract.

4. **Submit the Challenge**  
   Click the "Submit instance" button to complete the challenge and update your progress on the Ethernaut platform. Complete!!

## Conclusion

This challenge highlights the risks of using `delegatecall` without proper access control. By exploiting the fallback function, an attacker can execute arbitrary code in the context of the vulnerable contract, leading to unauthorized state changes such as taking ownership. Developers should always validate and restrict access to critical functions and avoid blindly forwarding calls using `delegatecall`. Proper implementation of access control mechanisms is essential to ensure the security of smart contracts.

