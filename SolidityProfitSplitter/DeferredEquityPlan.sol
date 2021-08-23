pragma solidity ^0.5.0;

// lvl 3: equity plan
contract DeferredEquityPlan {
    uint fakenow = now;
    address human_resources;

    address payable employee; // bob
    bool active = true; // this employee is active at the start of the contract

    uint total_shares = 1000;
    uint annual_distribution = 250;

    uint start_time = now; // permanently store the time this contract was initialized
    uint unlock_time = now + 365 days;
    // @TODO: Set the `unlock_time` to be 365 days from now
    // Your code here!

    uint public distributed_shares; // starts at 0

    constructor(address payable _employee) public {
        human_resources = msg.sender;
        employee = _employee;
    }

    function distribute() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to execute this contract.");
        require(active == true, "Contract not active.");
        require(unlock_time <= now, "Annual vesting period not realized");
        require(distributed_shares < total_shares, "All your shares have been distributed");

        unlock_time = unlock_time + 365 days;

        // @TODO: Calculate the shares distributed by using the function (now - start_time) / 365 days * the annual distribution
        // Make sure to include the parenthesis around (now - start_time) to get accurate results!
        // Your code here!
        
        distributed_shares = (now - start_time) / 365 days * annual_distribution;

        // double check in case the employee does not cash out until after 5+ years
        if (distributed_shares > 1000) {
            distributed_shares = 1000;
        }
    }
    
    function fastforward() public {
        fakenow += 100 days;
    }

    // human_resources and the employee can deactivate this contract at-will
    function deactivate() public {
        require(msg.sender == human_resources || msg.sender == employee, "You are not authorized to deactivate this contract.");
        active = false;
    }

    // Since we do not need to handle Ether in this contract, revert any Ether sent to the contract directly
    function() external payable {
        revert("Do not send Ether to this contract!");
    }
}
