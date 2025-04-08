# First way (quite difficult)

# Gate 1:
Solution to the first gate is trivial, just use a contract as a middleman. From previous puzzles we have learned that `msg.sender` is the immediate sender of a transaction, which may be a contract; however, `tx.origin` is the originator of the transaction which is usually you.

# Gate 3:
This gate involves checks that require explicit conversions between uints. From the third `require` statement, it can be inferred that the `_gateKey` should be derived from `tx.origin` through casting while satisfying other conditions.

`tx.origin` will be the player, which in this case is:

`0xd557a44ed144bf8a3da34ba058708d1b4bc0686a`

We are only concerned with the last 8 bytes of it since `_gateKey` is of type `bytes8` (8 bytes in size). Specifically, the last 8 bytes of `tx.origin` are:

`key = 58 70 8d 1b 4b c0 68 6a`

Accordingly, `uint32(uint64(key)) = 4b c0 68 6a`.

To satisfy the third `require`, the following condition must hold:

`uint32(uint64(key)) == uint16(tx.origin)`

This is only possible by applying a mask of `00 00 ff ff`, such that:

`4b c0 68 6a & 00 00 ff ff = 68 6a`

Thus, the mask is:

`mask = 00 00 ff ff`

The first `require` is satisfied by:

`uint32(uint64(_gateKey)) == uint16(uint64(key))`

This is the same problem as the previous one and can be achieved using the same mask value.

The second `require` asks to satisfy:

`uint32(uint64(key)) != uint64(key)`

This means:

`4b c0 68 6a != 58 70 8d 1b 4b c0 68 6a`

To achieve this, we modify the mask to:

`mask = ff ff ff ff 00 00 ff ff`

This ensures:

`00 00 00 00 4b c0 68 6a & ff ff ff ff 00 00 ff ff != 58 70 8d 1b 4b c0 68 6a`

while also satisfying the other two `require` conditions.

Hence, the `_gateKey` should be:

`_gateKey = key & mask`

or:

`_gateKey = 58 70 8d 1b 4b c0 68 6a & ff ff ff ff 00 00 ff ff`

## Gate 2

To pass Gate 2, the remaining gas after the `gasleft` call must be a multiple of 8191. This can be controlled by carefully setting the gas amount sent with the transaction. The steps to achieve this are as follows:

1. **Estimate Gas Used**:
   - Deploy the `GatekeeperOne` contract in Remix using the JavaScript VM environment.
   - Deploy the helper contract `GateKeeperOneGasEstimate` to assist in estimating gas usage:

     ```solidity
     // SPDX-License-Identifier: MIT
     pragma solidity ^0.6.0;

     contract GateKeeperOneGasEstimate {
         function enterGate(address _gateAddr, uint256 _gas) public returns (bool) {
             bytes8 gateKey = bytes8(uint64(tx.origin));
             (bool success, ) = address(_gateAddr).call.gas(_gas)(abi.encodeWithSignature("enter(bytes8)", gateKey));
             return success;
         }
     }
     ```

   - Choose an initial gas amount (e.g., 90000) and call `enterGate` with the address of the deployed `GatekeeperOne` contract and the chosen gas value.
   - Use Remix's Debug feature to locate the `gasleft` opcode in the execution trace. Note the remaining gas at this point.

2. **Calculate Required Gas**:
   - Compute the gas used up to the `gasleft` call:

     ```
     gasUsed = initialGas - remainingGas
     ```

   - Determine the required gas to make the remaining gas a multiple of 8191:

     ```
     requiredGas = (8191 * multiplier) + gasUsed
     ```

     Here, `multiplier` is an arbitrary positive integer that ensures sufficient gas for the transaction.

3. **Iterate to Find Correct Gas**:
   - Use a margin around the calculated `requiredGas` to account for potential differences in the target contract's environment. For example:

     ```solidity
     contract GatePassOne {
         event Entered(bool success);

         function enterGate(address _gateAddr, uint256 _gas) public returns (bool) {
             bytes8 key = bytes8(uint64(tx.origin));
             bool succeeded = false;

             for (uint i = _gas - 64; i < _gas + 64; i++) {
                 (bool success, ) = address(_gateAddr).call.gas(i)(abi.encodeWithSignature("enter(bytes8)", key));
                 if (success) {
                     succeeded = success;
                     break;
                 }
             }

             emit Entered(succeeded);
             return succeeded;
         }
     }
     ```

4. **Execute the Solution**:
   - Call `enterGate` with the `GatekeeperOne` address and the calculated gas value (e.g., 65782). Adjust the gas value within the margin until the gate is cleared.

# Another way (easy):

1. Just compile my code and deploy contract``GatekeeperOneAttack``  at the instance address. And perform ``attack()`` 
2. Submit and done!!