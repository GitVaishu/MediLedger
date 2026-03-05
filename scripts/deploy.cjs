
async function main() {

  const MediLedger = await ethers.getContractFactory("MediLedger");

  const contract = await MediLedger.deploy();

  await contract.waitForDeployment();

  console.log("Contract deployed to:", await contract.getAddress());

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });