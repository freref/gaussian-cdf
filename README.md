# Gaussian CDF

Solidity Zelen & Severo approximation of guassian CDF implementation.

## Usage

### Build

```
forge build
```

### Test

Tests use `test_cases.txt`. You can use this file as is or generate new test cases by running `python3 generate_tests.py` after having installed the necessary dependencies in `requirements.txt`. I use a similar structure as [marcuspang](https://github.com/marcuspang/paradigm-guassian).

```
forge test -vv
```
