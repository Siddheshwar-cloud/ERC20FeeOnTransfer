# ERC20 Fee On Transfer Token

<div align="center">
  <a href="https://docs.soliditylang.org/en/v0.8.20/"><img src="https://img.shields.io/badge/Solidity-0.8.20-363636?style=for-the-badge&logo=solidity" alt="Solidity"></a>
  <a href="https://hardhat.org/"><img src="https://img.shields.io/badge/Hardhat-Framework-yellow?style=for-the-badge&logo=hardhat" alt="Hardhat"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge" alt="License"></a>
  <a href="https://hardhat.org/hardhat-network/docs"><img src="https://img.shields.io/badge/Network-Local-green?style=for-the-badge" alt="Network"></a>
  <a href="https://eips.ethereum.org/EIPS/eip-20"><img src="https://img.shields.io/badge/Standard-ERC20-purple?style=for-the-badge" alt="ERC20"></a>
  <a href="https://ethereum.org/"><img src="https://img.shields.io/badge/Ethereum-Blockchain-627EEA?style=for-the-badge&logo=ethereum" alt="Ethereum"></a>
</div>

<div align="center">
  <h3>ERC20 token with automatic fee collection on every transfer</h3>
  <p>Perfect for sustainable tokenomics, rewards distribution, and deflationary mechanics</p>
  
  <br>
  
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#deployment">Deployment</a> •
  <a href="#usage-examples">Usage</a> •
  <a href="#author">Author</a>
  
  <br><br>
  
  <img src="https://img.shields.io/github/last-commit/Siddheshwar-cloud/ERC20FeeOnTransfer?style=flat-square" alt="Last Commit">
  <img src="https://img.shields.io/github/languages/code-size/Siddheshwar-cloud/ERC20FeeOnTransfer?style=flat-square" alt="Code Size">
  <img src="https://img.shields.io/github/languages/top/Siddheshwar-cloud/ERC20FeeOnTransfer?style=flat-square" alt="Top Language">
</div>

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Fee Mechanism](#fee-mechanism)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Contract Details](#contract-details)
- [Deployment](#deployment)
- [Usage Examples](#usage-examples)
- [Use Cases](#use-cases)
- [Author](#author)

---

## Overview

ERC20FeeOnTransfer implements an automatic fee mechanism that deducts a percentage from every token transfer and sends it to a designated treasury address. This creates sustainable tokenomics for projects requiring ongoing revenue, reward distribution, or deflationary mechanisms.

### Key Highlights

- **Automatic Fee Collection**: Fees deducted on every transfer
- **Configurable Fee Rate**: Owner can adjust fee (max 10%)
- **Treasury Management**: Dedicated address for fee collection
- **Basis Points System**: Precise fee control (1 bps = 0.01%)
- **Admin Controls**: Update treasury and fee rate
- **Standard ERC20**: Fully compatible with wallets and DEXs

---

## Features

| Feature | Description |
|---------|-------------|
| **Transfer Fee** | Automatic fee on every transfer |
| **Basis Points** | Precise fee control (e.g., 200 = 2%) |
| **Treasury Address** | Dedicated fee collection address |
| **Adjustable Fee** | Owner can update fee rate |
| **Max Fee Cap** | Maximum 10% to prevent abuse |
| **Admin Functions** | Update treasury and fee settings |

---

## Fee Mechanism

### How Transfer Fees Work

When a user transfers 1000 tokens with a 2% fee (200 basis points):

```
Transfer Amount: 1000 tokens
Fee (2%): 20 tokens
Recipient Receives: 980 tokens
Treasury Receives: 20 tokens
```

### Basis Points Explained

| Fee BPS | Percentage | Example on 1000 tokens |
|---------|------------|------------------------|
| 0 | 0% | Fee: 0, Receive: 1000 |
| 100 | 1% | Fee: 10, Receive: 990 |
| 200 | 2% | Fee: 20, Receive: 980 |
| 300 | 3% | Fee: 30, Receive: 970 |
| 500 | 5% | Fee: 50, Receive: 950 |
| 1000 | 10% | Fee: 100, Receive: 900 |

---

## Architecture

### Contract Structure

```
ERC20FeeOnTransfer
├── ERC20 Core
│   ├── name, symbol, decimals
│   ├── totalSupply, balanceOf, allowance
│   ├── transfer()
│   ├── approve()
│   └── transferFrom()
├── Fee System
│   ├── feeBps (basis points)
│   ├── treasury (fee recipient)
│   └── _transfer() - internal with fee logic
├── Admin Functions
│   ├── updateTreasury() - onlyOwner
│   └── updateFee() - onlyOwner
└── Events
    ├── Transfer (x2 per transaction)
    ├── TreasuryUpdated
    └── FeeUpdated
```

---

## Getting Started

### Prerequisites

- Node.js v16+
- npm or yarn
- Git
- Hardhat

### Installation

```bash
# Clone repository
git clone https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer.git
cd ERC20FeeOnTransfer

# Install dependencies
npm install
```

### Project Structure

```
ERC20FeeOnTransfer/
├── contracts/
│   └── ERC20FeeOnTransfer.sol
├── scripts/
│   └── deploy.js
├── hardhat.config.js
└── README.md
```

---

## Contract Details

### State Variables

```solidity
string public name;               // Token name
string public symbol;             // Token symbol
uint8 public decimals = 18;      // Decimal places
uint256 public totalSupply;      // Total supply
address public owner;            // Contract owner
address public treasury;         // Fee recipient
uint256 public feeBps = 200;     // Fee in basis points (2%)
```

### Constructor

```solidity
constructor(
    string memory _name,
    string memory _symbol,
    uint256 _initialSupply,
    address _treasury
)
```

**Parameters:**
- `_name`: Token name
- `_symbol`: Token symbol
- `_initialSupply`: Initial supply (without decimals)
- `_treasury`: Address to receive fees

---

### Main Functions

#### transfer()

Transfer tokens with automatic fee deduction.

```javascript
await token.transfer(recipient, ethers.parseUnits("1000", 18));
// Recipient gets: 980 tokens
// Treasury gets: 20 tokens (2% fee)
```

#### updateTreasury()

Changes the treasury address. **Owner only.**

```javascript
await token.updateTreasury(newTreasuryAddress);
```

#### updateFee()

Updates the fee rate. **Owner only.**

```javascript
await token.updateFee(300); // Set fee to 3%
```

---

## Deployment

### Local Network

```bash
# Terminal 1: Start node
npx hardhat node

# Terminal 2: Deploy
npx hardhat run scripts/deploy.js --network localhost
```

### Configuration

Update in `deploy.js`:
```javascript
const token = await Token.deploy(
  "FeeToken",
  "FEE",
  1_000_000,
  "0xYourTreasuryAddress" // Change this!
);
```

---

## Usage Examples

### Basic Transfer with Fee

```javascript
const { ethers } = require("hardhat");

async function main() {
  const Token = await ethers.getContractFactory("ERC20FeeOnTransfer");
  const [owner, treasury, user1] = await ethers.getSigners();
  
  const token = await Token.deploy(
    "FeeToken",
    "FEE",
    1_000_000,
    treasury.address
  );
  await token.waitForDeployment();
  
  console.log("Token deployed:", await token.getAddress());
  
  // Transfer 1000 tokens
  await token.transfer(user1.address, ethers.parseUnits("1000", 18));
  
  // Check balances
  const user1Bal = await token.balanceOf(user1.address);
  const treasuryBal = await token.balanceOf(treasury.address);
  
  console.log("User1 received:", ethers.formatUnits(user1Bal, 18)); // 980
  console.log("Treasury received:", ethers.formatUnits(treasuryBal, 18)); // 20
}

main();
```

### Update Fee Rate

```javascript
async function updateFeeExample() {
  const [owner] = await ethers.getSigners();
  const token = await ethers.getContractAt("ERC20FeeOnTransfer", "TOKEN_ADDRESS");
  
  // Current fee
  let fee = await token.feeBps();
  console.log("Current Fee:", fee.toString(), "bps");
  
  // Update to 5%
  await token.updateFee(500);
  
  fee = await token.feeBps();
  console.log("New Fee:", fee.toString(), "bps");
}
```

---

## Use Cases

### 1. Reward Distribution Token

Automatic collection of fees for staking rewards.

### 2. Project Sustainability

Fees fund ongoing development and operations.

### 3. Deflationary Token

Fees sent to burn address reduce supply over time.

### 4. Liquidity Provision

Fees automatically add to liquidity pool.

### 5. DAO Treasury

Fees fund governance and community proposals.

---

## Security Features

- **Fee Cap Protection**: Maximum 10% fee
- **Zero Address Validation**: Prevents invalid transfers
- **Owner-Only Admin**: Restricted treasury/fee updates
- **Integer Overflow Protection**: Solidity 0.8.20 built-in

---

## FAQ

**Q: Can I exempt addresses from fees?**
A: Not in this version. Consider adding whitelist for v2.

**Q: What's the maximum fee?**
A: 10% (1000 basis points) to prevent abuse.

**Q: Can treasury be a burn address?**
A: Yes, making the token deflationary.

**Q: Are fees charged on approve?**
A: No, only on actual transfers.

---

## Technology Stack

| Technology | Version | Purpose |
|------------|---------|---------|
| Solidity | ^0.8.20 | Contract language |
| Hardhat | Latest | Development |
| Ethers.js | v6 | Interactions |
| Node.js | v16+ | Runtime |

---

## Author

<div align="center">
  
  <img src="https://img.shields.io/badge/Crafted%20with-❤️-red?style=for-the-badge" alt="Made with Love">
  <img src="https://img.shields.io/badge/Built%20by-Sidheshwar%20Yengudle-blue?style=for-the-badge" alt="Author">
  
</div>

<br>

<div align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=28&pause=1000&color=2E9EF7&center=true&vCenter=true&width=600&lines=Blockchain+Developer;Smart+Contract+Engineer;Tokenomics+Expert;DeFi+Specialist" alt="Typing SVG" />
</div>

<br>

<table align="center">
  <tr>
    <td align="center" width="200">
      <img src="https://img.icons8.com/fluency/96/000000/github.png" width="50" alt="GitHub"/>
      <br><strong>GitHub</strong>
      <br><a href="https://github.com/Siddheshwar-cloud">@Siddheshwar-cloud</a>
    </td>
    <td align="center" width="200">
      <img src="https://img.icons8.com/fluency/96/000000/linkedin.png" width="50" alt="LinkedIn"/>
      <br><strong>LinkedIn</strong>
      <br><a href="https://www.linkedin.com/in/sidheshwar-yengudle-113882241/">Connect</a>
    </td>
    <td align="center" width="200">
      <img src="https://img.icons8.com/fluency/96/000000/twitter.png" width="50" alt="Twitter"/>
      <br><strong>Twitter</strong>
      <br><a href="https://x.com/SYangudale">@SYangudale</a>
    </td>
  </tr>
</table>

<div align="center">
  
  <br>
  
  [![GitHub](https://img.shields.io/badge/GitHub-Siddheshwar--cloud-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Siddheshwar-cloud)
  [![LinkedIn](https://img.shields.io/badge/LinkedIn-Sidheshwar%20Yengudle-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sidheshwar-yengudle-113882241/)
  [![Twitter](https://img.shields.io/badge/Twitter-@SYangudale-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://x.com/SYangudale)

</div>

<div align="center">

### Skills & Expertise

<img src="https://skillicons.dev/icons?i=solidity,ethereum,nodejs,javascript,typescript,git,github,vscode&theme=dark" alt="Skills"/>

</div>

---

## Show Your Support

<div align="center">
  
[![GitHub Star](https://img.shields.io/github/stars/Siddheshwar-cloud/ERC20FeeOnTransfer?style=social)](https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer)

<a href="https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer/stargazers">
  <img src="https://img.shields.io/badge/⭐_Star_This_Repository-100000?style=for-the-badge&logo=github&logoColor=white" alt="Star">
</a>

**Your star helps others discover sustainable tokenomics!**

</div>

<br>

### Repository Links

<div align="center">

[![View](https://img.shields.io/badge/View-Repository-black?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer)
[![Fork](https://img.shields.io/badge/Fork-Repository-green?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer/fork)
[![Issues](https://img.shields.io/badge/Report-Issues-red?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer/issues)
[![PRs](https://img.shields.io/badge/Submit-PR-orange?style=for-the-badge&logo=github)](https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer/pulls)

</div>

---

## Buy Me A Coffee

<div align="center">

If this project helped you, consider supporting my work!

<br>

### Crypto Donations

**Solana Wallet:**
```
G9LUNsQfMgcRqWS2X9mcNf4kNhRWoxcZZri3p2ay7Yaf
```

<a href="https://solscan.io/account/G9LUNsQfMgcRqWS2X9mcNf4kNhRWoxcZZri3p2ay7Yaf">
  <img src="https://img.shields.io/badge/Donate-Crypto-orange?style=for-the-badge&logo=solana" alt="Crypto">
</a>

<br><br>

### UPI Payment (India)

**UPI ID:** `shidheshoryangudale-2@okicici`

<br>

<a href="upi://pay?pa=shidheshoryangudale-2@okicici&pn=Sidheshwar%20Yengudle&cu=INR">
  <img src="https://img.shields.io/badge/Pay-UPI-green?style=for-the-badge&logo=googlepay" alt="UPI">
</a>

<br><br>

**Every contribution is appreciated!** 🙏

</div>

---

## Contributing

Ideas welcome:
- Fee exemption whitelist
- Gradual fee changes
- Multi-tier fee structure
- Fee burn mechanism

---

## License

MIT License

```
Copyright (c) 2026 Sidheshwar Yengudle
```

---

<div align="center">
  <p>Made with dedication to sustainable tokenomics</p>
  
  <br>
  
  <a href="https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer#erc20-fee-on-transfer-token">
    <img src="https://img.shields.io/badge/💰-Fee%20System-4CAF50?style=for-the-badge" alt="Fee">
  </a>
  <a href="https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer#fee-mechanism">
    <img src="https://img.shields.io/badge/🏦-Treasury-2196F3?style=for-the-badge" alt="Treasury">
  </a>
  <a href="https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer#contract-details">
    <img src="https://img.shields.io/badge/⚙️-Configurable-FF9800?style=for-the-badge" alt="Config">
  </a>
  
  <br><br>
  
  **Automatic Fees, Sustainable Growth!**
  
  <br>
  
  <a href="https://github.com/Siddheshwar-cloud/ERC20FeeOnTransfer#erc20-fee-on-transfer-token">
    <img src="https://img.shields.io/badge/⬆️_Back_to_Top-100000?style=for-the-badge&logo=github&logoColor=white" alt="Top">
  </a>
  
  <br><br>
  
  Made with ❤️ and ☕ by Sidheshwar Yengudle © 2026
  
  <br><br>
  
  <a href="https://github.com/Siddheshwar-cloud">
    <img src="https://img.shields.io/badge/More_Projects-Explore-blue?style=for-the-badge&logo=github" alt="More">
  </a>
  
</div>
