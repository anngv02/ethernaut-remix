# Solution for Level 0: Hello Ethernaut

To "attack" (complete) Level 0: Hello Ethernaut, follow these steps based on the provided instructions:

1. **Preparation**  
   - Ensure you have read the instructions for Level 0 and have test ether.  
   - The contract's methods will be available in your browser console, allowing you to call them.

2. **Step-by-Step Instructions**  

   - Call the `info()` method in the console:  
     ```javascript
     await contract.info();
     ```  
     Result: `'You will find what you need in info1().'`

   - Next, call the `info1()` method:  
     ```javascript
     await contract.info1();
     ```  
     Result: `'Try info2(), but with "hello" as a parameter.'`

   - Follow the instructions and call `info2()` with the parameter `"hello"`:  
     ```javascript
     await contract.info2("hello");
     ```  
     Result: `'The property infoNum holds the number of the next info method to call.'`

   - Retrieve the value of `infoNum` by calling its public getter:  
     ```javascript
     await contract.infoNum().then(v => v.toString());
     ```  
     Result: `42`  
     *(Note: `infoNum()` returns a BigNumber object, so you need to convert it to a string to see the actual number.)*

   - Proceed with `info42`:  
     ```javascript
     await contract.info42();
     ```  
     Result: `'theMethodName is the name of the next method.'`

   - Call the method returned by `info42`, which is `theMethodName()`:  
     ```javascript
     await contract.theMethodName();
     ```  
     Result: `'The method name is method7123949.'`

   - Call the method `method7123949()`:  
     ```javascript
     await contract.method7123949();
     ```  
     Result: `'If you know the password, submit it to authenticate().'`

   - To find the password, inspect the contract's ABI by entering `contract` in the console. You will see a method named `password`.

   - Call the `password()` method:  
     ```javascript
     await contract.password();
     ```  
     Result: `'ethernaut0'`

   - Finally, call the `authenticate()` method with the retrieved password:  
     ```javascript
     await contract.authenticate('ethernaut0');
     ```  
     Confirm the transaction in Metamask and submit the instance to complete the level.