const { v4: uuidv4 } = require('uuid');

async function main() {
    const contractAddress = "0x4D2D24899c0B115a1fce8637FCa610Fe02f1909e";
    const PublicationManager = await ethers.getContractFactory("PublicationManager");
    const contract = PublicationManager.attach(contractAddress);

    //const id = uuidv4();
    const doi = "00000001";
    const title = "Teste 1";
    const authors = ["Autor 1", "Autor 2"];
    const institution = "Instituição 1";
    const year = 2001;
    const citations = [];

    const tx = await contract.createPublication(doi, title, authors, institution, year, citations);
    res = await tx.wait();
    
    console.log(res)
    console.log(`Publicação criada: ${doi}, ${title}, ${authors}, ${institution}, ${year}, ${citations}`);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });