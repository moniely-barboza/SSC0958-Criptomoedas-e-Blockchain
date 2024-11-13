const publications = [
    ["10.2139/ssrn.2709713", "Blockchain Technology and Decentralized Governance: Is the State Still Necessary?", []], 
    ["10.1007/978-3-662-53357-4_8", "On scaling decentralized blockchains (A position paper)", []],
    ["10.1007/s12599-017-0467-3", "Blockchain", ["10.2139/ssrn.2709713", "10.1007/978-3-662-53357-4_8"]]
];

async function main() {
    const contractAddress = "0x7f1Dc0F5F8dafd9715Ea51f6c11b92929b2Dbdea";
    const PublicationManager = await ethers.getContractFactory("PublicationManager");
    const contract = PublicationManager.attach(contractAddress);

    for (const [doi, title, references] of publications) {
        const tx = await contract.createPublication(doi, title, references);
        await tx.wait();
        console.log(`Publicação criada: ${doi}, ${title}, ${references}`);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });