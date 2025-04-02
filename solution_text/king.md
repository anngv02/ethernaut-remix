## Introduction

The `King` challenge demonstrates how smart contracts can be disrupted by malicious actors through denial-of-service (DoS) attacks. This challenge highlights the importance of carefully designing fallback functions and handling external calls.

## Target

The goal of this challenge is to become the king of the contract and prevent others from claiming the throne by exploiting a vulnerability in the `King` contract.

## Context

The `King` contract implements a game where the current "king" is the address that sends the highest amount of Ether to the contract. The previous king is compensated with the Ether sent by the new king. However, the contract relies on the `transfer` function to send Ether to the previous king, which can be exploited to disrupt the contract's functionality.

## Security Vulnerability

The vulnerability lies in the `receive` function of the `King` contract. When a new king sends Ether to the contract, the `receive` function attempts to transfer Ether to the previous king using `payable(king).transfer(msg.value)`. If the previous king is a contract with a fallback function that reverts or consumes excessive gas, the transfer will fail, effectively locking the contract and preventing new kings from being set.

## Exploit Steps

To attack level 9 (King) of the Ethernaut game, the goal is to prevent the current level from reclaiming the kingship after the player submits the instance. The kingship is switched in the `receive` function when a specific value is sent to the `King` contract. Therefore, we need to find a way to prevent the execution of the `receive` function.

The crucial point to notice is that the previous king is sent back `msg.value` using `transfer`. However, what if this previous king was a contract that did not implement any `receive` or `fallback` function? It would not be able to receive any value. Because of this, the `transfer` command will stop execution and cause an exception (unlike `send`). This is the vulnerability to exploit.

### Steps to Execute the Attack

1. **Create the Exploit Contract**  
    Deploy a contract named `ForeverKing` that has no `receive` or `fallback` function:
    ```solidity
    // SPDX-License-Identifier: MIT
    pragma solidity ^0.6.0;

    contract Attacker {
        error Attacker__CallFailed();

        function attack(address _kingAddr) external payable {
            (bool success,) = payable(_kingAddr).call{value: msg.value}("");
            if(!success) revert Attacker__CallFailed();
        }
    }
    ```

2. **Determine the Current Prize**  
    Query the current prize of the `King` contract. For example, at least `1000000000000000` wei might be required to claim kingship. You can query this value using the following command:
    ```javascript
    // Example command to query the prize
    await contract.prize().then(v => v.toString())
    ```

3. **Get the Instance Address**  
    Retrieve the instance address of the `King` contract.
    ``` javascript
    contract.address
    ```

4. **Claim Kingship**  
    Call the `claimKingship` function of the `ForeverKing` contract with the instance address of the `King` contract as the parameter. Set the value equal to the current prize (or greater) in Remix. This will make the `ForeverKing` contract the king.

5. **Submit the Instance**  
    Once the `ForeverKing` contract becomes the king, submit the instance to complete the challenge.

## Conclusion

This challenge demonstrates the risks of relying on external calls in smart contracts, especially when interacting with unknown or untrusted addresses. To mitigate such vulnerabilities, developers should avoid using `transfer` or `call` without proper safeguards and consider alternative designs that do not depend on external contract behavior.
