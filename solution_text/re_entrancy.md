# Reentrancy Attack in Solidity

## 1. Introduction

Smart contracts on blockchains like Ethereum handle valuable assets, making their security paramount. One of the most notorious vulnerabilities in Solidity smart contracts is known as **Reentrancy**. This vulnerability typically arises when a contract interacts with an external contract (e.g., sending Ether) before it updates its own internal state (like balances). 

The recommended secure pattern to prevent this is **"Checks-Effects-Interactions" (CEI)**, where the contract:
1. First checks preconditions.
2. Then applies the effects to its internal state.
3. Finally performs interactions with external contracts.

When the Interaction step precedes the Effect step, it opens the door for a malicious contract to recursively call back into the vulnerable function, potentially draining its funds before the initial call completes and the state is updated.

---

## 2. Objective

The objective of the Reentrancy attack demonstrated by the provided `Attacker` contract is to exploit a flawed `withdraw` function within a target contract (represented by the `IReentrance` interface). 

The goal is to repeatedly execute the withdrawal logic within the target contract before it can update the attacker's balance, thereby draining the target contract of its Ether reserves significantly beyond the attacker's legitimate entitlement.

---

## 3. Attack Method

The attack leverages the incorrect ordering within the target contract's presumed `withdraw` function, where the Ether transfer (**Interaction**) happens before the balance deduction (**Effect**). The `Attacker` contract facilitates this as follows:

### Deployment and Initialization
- The attacker deploys the `Attacker` contract, providing the address of the vulnerable target contract (`_targetAddr`).

### Initial Deposit
- The attacker calls the `attack()` function on the `Attacker` contract, sending an initial amount of Ether (e.g., `0.001 ether` specified as `targetValue`).

### Donation
- Inside `attack()`, the `Attacker` contract first calls `targetContract.donate{value: msg.value}(address(this))`. 
- This sends the initial Ether to the target contract, crediting the `Attacker` contract's address within the target's internal balance tracking. 
- This step ensures the initial `require(balances[msg.sender] >= _amount)` check inside the target's `withdraw` function will pass.

### Initiating Withdrawal
- Immediately after donating, the `attack()` function calls `targetContract.withdraw(msg.value)`. 
- This triggers the vulnerable withdrawal process in the target contract.

### Exploiting Reentrancy
1. The target contract's `withdraw` function checks if the `Attacker` contract has sufficient balance (which it does, from the donation).
2. Crucially, the target contract then executes the Ether transfer (**Interaction**) to the `Attacker` contract's address before reducing the `Attacker`'s balance in its `balances` mapping (**Effect**).
3. The act of sending Ether to the `Attacker` contract triggers its `receive()` fallback function.
4. Inside the `receive()` function, the `Attacker` contract checks the target contract's current Ether balance (`address(targetContract).balance`).
5. If the target still holds sufficient funds (`>= targetValue`), the `Attacker` contract immediately calls `targetContract.withdraw(targetValue)` again.
6. Because the target contract still hasn't updated the `Attacker`'s balance from the first withdrawal call, the balance check passes again. The target sends more Ether, triggering `receive()` again.
7. This cycle repeats: **Check (passes) -> Interact (send Ether) -> `receive()` triggered -> Call `withdraw` again -> Check (passes)...**

### Draining Funds
- The loop continues, withdrawing `targetValue` repeatedly, until the target contract's balance is less than `targetValue`. 
- The final call in the `receive()` function attempts to withdraw the remaining balance.

### Final Retrieval
- Once the target contract is drained, the original owner of the `Attacker` contract can call its `withdraw()` function to transfer all the accumulated Ether from the `Attacker` contract to their own external account.

---

## 4. Conclusion

The Reentrancy attack remains a critical vulnerability in Solidity development. It exploits a logical flaw where external calls are made before internal state changes are finalized, breaking the atomic nature of a transaction's intended logic. 

The provided `Attacker` contract demonstrates a practical method to weaponize this flaw, recursively calling the target's `withdraw` function via its `receive()` fallback function to drain funds.

This specific attack pattern is historically significant, as it mirrors the mechanism used in the 2016 hack of **"The DAO,"** which led to the loss of millions of dollars worth of Ether and ultimately resulted in a controversial hard fork of the Ethereum blockchain, creating Ethereum Classic. 

Adhering strictly to the **Checks-Effects-Interactions** pattern, or employing alternative secure designs like the **pull-payment strategy** (where recipients must initiate the withdrawal themselves), is essential to prevent such devastating attacks.