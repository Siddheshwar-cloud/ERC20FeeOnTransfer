const hre = require("hardhat");

async function main() {
  const Token = await hre.ethers.getContractFactory("ERC20FeeOnTransfer");

  const token = await Token.deploy(
    "FeeToken",
    "FEE",
    1_000_000,
    "0x000000000000000000000000000000000000dEaD" // treasury
  );

  await token.waitForDeployment();

  console.log("ERC20FeeOnTransfer deployed to:", await token.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
