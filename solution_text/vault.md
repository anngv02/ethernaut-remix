## Introduction

The `Vault` contract is a simple smart contract that stores a private `password` and a `locked` state. The goal is to unlock the vault by providing the correct password. This challenge demonstrates how private variables in Solidity can still be accessed due to the transparency of the Ethereum blockchain.

## Target

The objective is to unlock the vault by exploiting the fact that private variables in Solidity are not truly private and can be read from the blockchain's storage.

## Context

In Solidity, all contract data is stored on the blockchain, and even private variables can be accessed by reading the storage slots directly. This behavior can lead to vulnerabilities if sensitive data is stored as private variables without additional encryption or obfuscation.

## Security Vulnerability

The vulnerability lies in the misconception that private variables in Solidity are inaccessible. In reality, all contract data is stored on the blockchain and can be accessed by anyone with the right tools. This makes it unsafe to store sensitive information as private variables without additional security measures.

## Exploit steps

1. Identify the storage slot of the `password` variable. The `password` variable is located at storage slot 1.

2. Read the value stored at that storage slot. The source provides an example of how to do this using 
``` javascript 
    password == web3.eth.getStorageAt(contract.address, 1)
```
This allows you to read the value of the `password` variable even though it is declared as private.

3. Call the `unlock` function of the contract with the retrieved password. You can call the function using `contract.unlock()` after obtaining the password.
``` javascript 
    await contract.unlock()
```

4. Verify that the contract has been unlocked by checking the value of the `locked` variable, which will be `false` after successfully calling the `unlock` function.
``` javascript 
    await contract.locked() === false
```

## Conclusion

This exploit highlights the importance of understanding the limitations of Solidity's `private` keyword. Developers should avoid storing sensitive information directly on-chain or use encryption to protect such data. By understanding and addressing these vulnerabilities, developers can create more secure smart contracts.