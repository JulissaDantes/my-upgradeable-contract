//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


interface IPool {
    function getEtherPrice() external view returns (uint256);
}

/** 
 * @title Collateralized Loan
 * @notice A user can lend up to 50% of their ether value in another token. At a Loan-to-Value ratio above 0.8 anybody can liquidate the position. Lending accrues interest over time.
 * @dev Token must have 18 decimals
 */
contract Loanv1 is OwnableUpgradeable {
    uint256 interestRate;
    address implementation;
    IERC20Upgradeable token;
    mapping(address => uint256) public ethbalance ;
    mapping(address => LoanData) public loan;
    IPool pool;
    bool alreadyinit;

    struct LoanData {
        uint256 amount;
        uint256 time;
    }

    function initializer1(address _token, address _pool) external {
        require(! alreadyinit, "The contract has already been initalized");
        token = IERC20Upgradeable(_token);
        pool = IPool(_pool);
    }

    /**
     * @dev computes amount of tokens owed by user
     * @param user address of user
     */
    function getOutstandingLoan(address user) public view returns (uint256)  {
        uint256 dur = block.timestamp - loan[user].time;
        return (loan[user].amount * (1e18 + (interestRate * dur))) / 1e18;
    }

    function getRate() external view returns(uint256) {
        return interestRate;
    }


    /// @dev Allows any user to deposit ether as collateral to lend against it.
    /// @param amount The amount of ether the use wants to withdraw from their collateral
    function depositCollateral(uint256 amount) external payable {
        require(amount == msg.value, "Amount does not match transfer amount");
        ethbalance[msg.sender] += amount;
    }

    /**
     * @dev Allows any user to withdraw a part of their ether collateral as long as the outstanding loan has less than 50% of the remaining ether value.
     * @param amount The amount of ether the used want to withdraw from their collateral
     */
    function withdrawCollateral(uint256 amount) external payable {
        require(loan[msg.sender].amount == 0, "Cannot withdraw collateral with outstanding debt");
        ethbalance[msg.sender] -= amount;
        (bool success, ) = (msg.sender).call{value: amount}("");
        require(success, "Withdrawing collateral failed");
    }

    /** 
     * @dev Allows anyone to lend up to 50% of deposited ether in USDC
     * @param amount The amount of USDC the user intends to receive
     */
    function loanToken(uint256 amount) external {
        uint256 ethprice = pool.getEtherPrice();
        uint256 maxloan = ethbalance[msg.sender] * ethprice / 2 / 1e18;
        uint256 available = maxloan - getOutstandingLoan(msg.sender);
        require(available >= amount, "Insufficient Ether balance for loan request");
        uint256 tobesend = available;
        token.transfer(msg.sender, tobesend);
        loan[msg.sender].amount += tobesend;
        // update average loan-out time
        loan[msg.sender].time = (block.timestamp * tobesend +   loan[msg.sender].time* (loan[msg.sender].amount - tobesend)) / loan[msg.sender].amount;
    }

    /**
     * @dev allows full or partial repayment of loan
     * @param amount amount of tokens to repay
     */
    function repayLoan(uint256 amount) external payable {
        uint256 curLoan = getOutstandingLoan(msg.sender);
        token.transferFrom(msg.sender, address(this), amount);
        loan[msg.sender].amount = curLoan - amount;
        loan[msg.sender].time = block.timestamp;
    }

    /** 
     * @dev Allows anybody (no capital requirement) to flash liquidate a loan of insufficient collateralization
     * @param user The address of the user whos loan to liquidate
     */
    function liquidate(address user) external {
        require((getOutstandingLoan(user)* 8) / 10 > (ethbalance[user] * pool.getEtherPrice()) / 1e18);
        // get token balance reference
        uint256 oldbalance = token.balanceOf(address(this));
        //give Ether to liquidator
        (bool success, ) = (msg.sender).call{value: ethbalance[user]}("");
        require(success, "Transfer of liquidation funds failed");
        // compare with loan amount
        uint256 newbalance = token.balanceOf(address(this));
        require(newbalance - oldbalance >= getOutstandingLoan(user), "Payback insufficient");
        //forgive loan and consume balance
        ethbalance[user] = 0;
        loan[user].amount = 0;
    }

    /**
     * @dev Allows owner to perform an emergency Liquidation
     * @param user The user to perform an emergency liquidation on
     */
    function emergencyLiquidate(address user) external onlyOwner {
        ethbalance[user] = 0;
        loan[user].amount = 0;
    }

}