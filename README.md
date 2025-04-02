# ETHERNAUT GAME (Levels 0 to 20)

Explore solutions for Ethernaut levels 0 to 20. If you find them helpful, consider giving the repository a star to show your support!
# REMIX DEFAULT WORKSPACE

Remix Default Workspace is a foundational setup provided by Remix IDE under the following circumstances:

1. When Remix is launched for the first time.
2. When a new workspace is created using the 'Default' template.
3. When no files exist in the File Explorer.

### Workspace Structure

The default workspace includes three directories:

1. **`contracts`**: Contains three example contracts, each demonstrating varying levels of complexity.
2. **`scripts`**: Includes four TypeScript scripts designed to deploy contracts. Details are provided below.
3. **`tests`**: Contains a Solidity test file for the `Ballot` contract and a JavaScript test file for the `Storage` contract.

### Solution Reference

SOLUTION_TEXT folder also contains solutions for various assignments, which can be referred to as needed.

### Scripts Overview

The `scripts` directory provides TypeScript files to deploy the `Storage` contract using either the `web3.js` or `ethers.js` library. To deploy a different contract, update the contract name and constructor arguments in `deploy_with_ethers.ts` or `deploy_with_web3.ts`.

### Running Scripts

To execute a script:
1. Right-click the script file in the File Explorer.
2. Select 'Run' from the context menu.

Ensure the Solidity contract is compiled beforehand. The script's output will be displayed in the Remix terminal.

### Testing

The `tests` directory includes:
- A Mocha-Chai unit test for the `Storage` contract.
- A Solidity test for the `Ballot` contract.

### Notes on Module Support

Remix IDE supports a limited set of modules for `require`/`import`. Supported modules include:
- `ethers`
- `web3`
- `swarmgw`
- `chai`
- `multihashes`
- `remix`
- `hardhat` (limited to the `hardhat.ethers` object/plugin).

Attempting to use unsupported modules will result in an error: `<module_name> module require is not supported by Remix IDE`.

### Solution Reference

This folder also contains solutions for various assignments, which can be referred to as needed.