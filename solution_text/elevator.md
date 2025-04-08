## Introduction

The Elevator challenge in Ethernaut demonstrates how to exploit a contract that relies on external calls to determine its state. By understanding the vulnerability in the `Elevator` contract, we can manipulate its behavior to achieve the desired outcome.

## Target

The vulnerability in the `Elevator` contract lies in its reliance on the `Building` interface's `isLastFloor` function to determine whether the elevator has reached the top floor. Since the contract does not validate the source or logic of the `isLastFloor` function, an attacker can deploy a malicious contract (e.g., `MyBuilding`) that manipulates the return value of `isLastFloor` to exploit the `Elevator` contract.

## Exploit Steps

1. Verify the initial state of the contract by running the following command in the console:
    ```javascript
    await contract.top()
    ```
    The result should be `false`. If it is `true`, you can submit to complete the challenge.

2. Open the **Remix IDE**. Locate and copy the code from the `11_building` file in the GitHub repository. Compile the file.

3. Deploy the contract using the `MyBuilding` contract. Ensure the environment is set to **Injected Provider**.

4. Return to the console and retrieve the instance address. Use this address as the parameter for the `goToTop` function and execute the transaction.

5. After the transaction is successful, verify the state of the contract again by running:
    ```javascript
    await contract.top()
    ```
    If the result is `true`, the challenge is complete.

## Conclusion

This challenge highlights the importance of validating external calls and ensuring that contracts do not blindly trust external inputs. The `Elevator` contract's reliance on the `Building` interface without proper validation allowed an attacker to manipulate its state. Developers should always consider potential attack vectors when designing smart contracts, especially when external calls or interfaces are involved. Proper validation and secure coding practices can mitigate such vulnerabilities.