# REMIX DEFAULT WORKSPACE

Remix default workspace is present when:
1. Remix loads for the very first time.
2. A new workspace is created with the 'Default' template.
3. There are no files existing in the File Explorer.

This workspace contains 3 directories:

1. **`contracts`**: Holds three contracts with increasing levels of complexity.
2. **`scripts`**: Contains four TypeScript files to deploy a contract. It is explained below.
3. **`tests`**: Contains one Solidity test file for the `Ballot` contract and one JS test file for the `Storage` contract.

## SCRIPTS

The `scripts` folder has four TypeScript files which help to deploy the `Storage` contract using `web3.js` and `ethers.js` libraries.

For the deployment of any other contract, just update the contract name from `Storage` to the desired contract and provide constructor arguments accordingly in the file `deploy_with_ethers.ts` or `deploy_with_web3.ts`.

In the `tests` folder, there is a script containing Mocha-Chai unit tests for the `Storage` contract.

To run a script, right-click on the file name in the file explorer and click 'Run'. Remember, the Solidity file must already be compiled. Output from the script will appear in the Remix terminal.

## Notes

- `require`/`import` is supported in a limited manner for Remix-supported modules.
- Currently, modules supported by Remix are:
    - `ethers`
    - `web3`
    - `swarmgw`
    - `chai`
    - `multihashes`
    - `remix`
    - `hardhat` (only for `hardhat.ethers` object/plugin).

For unsupported modules, an error like this will be thrown: `<module_name> module require is not supported by Remix IDE`.
