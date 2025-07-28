# Controller Accounts on Starknet

## Specification

See [Controller Account](./docs/controller_account.md).

## Development

### Setup

We recommend you to install scarb through ASDF. Please refer to [these instructions](https://docs.swmansion.com/scarb/download.html#install-via-asdf).  
Thanks to the [.tool-versions file](./.tool-versions), you don't need to install a specific scarb or starknet foundry version. The correct one will be automatically downloaded and installed.

## Test the contracts

```
scarb test
```

You also have access to the linter and a code formatter:

```shell
scarb run lint
scarb run format
```

### Interface IDs

For compatibility reasons we support legacy interface IDs. But new interface IDs will follow [SNIP-5](https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-5.md#how-interfaces-are-identified)
Tool to calculate interface IDs: https://github.com/ericnordelo/src5-rs

## Release checklist

- Bump version if needed (new deployment in mainnet)
- Set up your .env file with the deployer info and run `scarb run deploy-account` to declare the account
- Verify the contracts if possible
- Deploy to as many environments as possible: mainnet, sepolia and integration
- Create release in GitHub if needed
- Make this checklist better if you learned something during the process
