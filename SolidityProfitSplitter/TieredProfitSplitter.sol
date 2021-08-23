pragma solidity ^0.5.0;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol";

// lvl 2: tiered split
contract TieredProfitSplitter {
    using SafeMath for uint;
    
    address payable employee_one; // ceo
    address payable employee_two; // cto
    address payable employee_three; // bob

    constructor(address payable _one, address payable _two, address payable _three) public {
        employee_one = _one;
        employee_two = _two;
        employee_three = _three;
    }

    // Should always return 0! Use this to test your `deposit` function's logic
    function balance() public view returns(uint) {
        return address(this).balance;
    }

    function deposit() public payable {
        uint points = msg.value / 100; // Calculates rudimentary percentage by dividing msg.value into 100 units
        uint total;
        uint amount;
        uint j;
        address payable [3] memory employees = [employee_one, employee_two, employee_three];
        uint8[3] memory percentages = [60, 25, 15];
        
        for(j=0; j<3; j++) {
            amount = points.mul(percentages[j]);
            employees[j].transfer(amount);
            total = total.add(amount);
        }

        employee_one.transfer(msg.value - total); // ceo gets the remaining wei
    }

    function() external payable {
        deposit();
    }
}
