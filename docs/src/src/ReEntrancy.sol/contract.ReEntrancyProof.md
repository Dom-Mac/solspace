# ReEntrancyProof

## State Variables
### balances
*Mapping of token holders and amounts*


```solidity
mapping(address => uint256) public balances;
```


## Functions
### withdraw

*Function to withdraw your holds*


```solidity
function withdraw() public;
```

### deposit

*Update the state before interaction*

*The external interaction is made AFTER the state's update*

*Check if the interaction was successful*

*Function to deposit funds*


```solidity
function deposit() public payable;
```

