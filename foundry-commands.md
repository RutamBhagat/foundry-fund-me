### Dependencies installation

```shell
forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit
```

This command installs the Chainlink Brownie contracts at version 1.1.1 without creating a commit.

### -v specifies the visibility of logging

```shell
forge test -vv
```

This runs all tests with increased verbosity (-vv). More 'v's increase the detail of the output.

### For running a specific test

```shell
forge test --match-test testPriceFeedVersionIsAccurate -vvvv --fork-url $SEPOLIA_RPC_URL
```

This runs a specific test that matches "testPriceFeedVersionIsAccurate" with maximum verbosity (-vvvv) and forks from the Sepolia network using the provided RPC URL.

### Coverage

```shell
forge coverage --fork-url $SEPOLIA_RPC_URL
```

This generates a code coverage report for your tests, forking from the Sepolia network.

### Gas cost

```shell
forge snapshot
```

This creates a gas snapshot of all your tests, showing the gas cost for each test.

```shell
forge snapshot --match-test testWithdrawFromMultipleFunders
# gas snapshot saved to .gas-snapshot
# FundMeTest:testWithdrawFromMultipleFunders() (gas: 530492)
```

This creates a gas snapshot for a specific test and saves it to .gas-snapshot file.

```shell
forge test --match-test testCheaperWithDrawFromMultipleFunders --gas-report

Ran 1 test for test/FundMe.t.sol:FundMeTest
[PASS] testWithDrawFromMultipleFundersCheaper() (gas: 1080013)
```

```shell
forge test --gas-report

Ran 10 tests for test/FundMe.t.sol:FundMeTest
[PASS] testAddsFunderToArrayOfFunders() (gas: 124221)
[PASS] testFundFailsWithoutEnoughETH() (gas: 47600)
[PASS] testFundUpdatesFundedDataStructure() (gas: 123881)
[PASS] testMinimumDollarIsFive() (gas: 8423)
[PASS] testOnlyOwnerCanWithDraw() (gas: 144675)
[PASS] testOwnerIsMsgSender() (gas: 8520)
[PASS] testPriceFeedVersionIsAccurate() (gas: 13665)
[PASS] testWithDrawFromMultipleFunders() (gas: 1080747)
[PASS] testWithDrawFromMultipleFundersCheaper() (gas: 1080013)
[PASS] testWithDrawWithASingleFunder() (gas: 153817)
Suite result: ok. 10 passed; 0 failed; 0 skipped; finished in 2.73ms (3.31ms CPU time)
```

This is used for providing gas reports for your tests.

```shell
forge storage
```

This command displays the storage layout of your contracts.

```shell
forge install ChainAccelOrg/foundry-devops --no-commit
```

This installs the foundry-devops library from ChainAccelOrg without creating a commit.

```shell
forge test -m testUserCanFundInteractions
```

This runs all tests that match "testUserCanFundInteractions".

These Forge commands are used for various tasks in Ethereum smart contract development:

1. Installing dependencies
2. Running tests with different verbosity levels
3. Running specific tests
4. Generating code coverage reports
5. Creating gas snapshots to analyze gas costs
6. Viewing contract storage layouts
7. Installing additional development tools

The commands often use options like `--fork-url` to simulate interactions on specific networks, `--match-test` to run specific tests, and `-v` to control verbosity of output. These tools help developers write, test, and optimize their smart contracts efficiently.
