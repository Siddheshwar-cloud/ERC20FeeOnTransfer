// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ERC20FeeOnTransfer {
    string public name;
    string public symbol;
    uint8 public decimals = 18;

    uint256 public totalSupply;
    address public owner;
    address public treasury;

    // Fee in basis points (e.g., 200 = 2%)
    uint256 public feeBps = 200;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TreasuryUpdated(address indexed oldTreasury, address indexed newTreasury);
    event FeeUpdated(uint256 oldFeeBps, uint256 newFeeBps);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _treasury
    ) {
        require(_treasury != address(0), "Invalid treasury");

        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        treasury = _treasury;

        totalSupply = _initialSupply * (10 ** uint256(decimals));
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    // ---------------- ERC20 CORE ----------------

    function transfer(address _to, uint256 _value) external returns (bool) {
        _transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool) {
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    // ---------------- INTERNAL TRANSFER LOGIC ----------------

    function _transfer(address _from, address _to, uint256 _value) internal {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");

        uint256 fee = (_value * feeBps) / 10_000;
        uint256 amountAfterFee = _value - fee;

        balanceOf[_from] -= _value;
        balanceOf[_to] += amountAfterFee;
        balanceOf[treasury] += fee;

        emit Transfer(_from, _to, amountAfterFee);
        emit Transfer(_from, treasury, fee);
    }

    // ---------------- ADMIN ----------------

    function updateTreasury(address _newTreasury) external onlyOwner {
        require(_newTreasury != address(0), "Invalid treasury");
        emit TreasuryUpdated(treasury, _newTreasury);
        treasury = _newTreasury;
    }

    function updateFee(uint256 _newFeeBps) external onlyOwner {
        require(_newFeeBps <= 1000, "Fee too high"); // max 10%
        emit FeeUpdated(feeBps, _newFeeBps);
        feeBps = _newFeeBps;
    }
}
