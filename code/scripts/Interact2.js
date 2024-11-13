
async function main() {
    const contractAddress = "0x7f1Dc0F5F8dafd9715Ea51f6c11b92929b2Dbdea";
    const PublicationManager = await ethers.getContractFactory("PublicationManager");
    const contract = PublicationManager.attach(contractAddress);

    const doi = "10.1007/s12599-017-0467-3";
    const title = "Blockchain";
    const doi_reference = "10.2139/ssrn.2709713";
    const title_reference = "Blockchain Technology and Decentralized Governance: Is the State Still Necessary?";

    try {
        const titleByDOI = await contract.getTitleByDOI(doi);
        console.log(`Título recuperado para o DOI ${doi}: "${titleByDOI}"`);
    } catch (error) {
        console.error("Erro ao recuperar o título:", error);
    }

    try {
        const doiByTitle = await contract.getDOIByTitle(title);
        console.log(`DOI recuperado para a publicação "${title}": ${doiByTitle}`);
    } catch (error) {
        console.error("Erro ao recuperar o DOI:", error);
    }

    try {
        const referencesByDOI = await contract.getReferencesByDOI(doi);
        console.log(`Referencias do DOI ${doi}: ${referencesByDOI}`);
    } catch (error) {
        console.error("Erro ao recuperar as referencias:", error);
    }

    try {
        const referencesByTitle = await contract.getReferencesByTitle(title);
        console.log(`Referencias da publicação "${title}": ${referencesByTitle}`);
    } catch (error) {
        console.error("Erro ao recuperar as referencias:", error);
    }

    try {
        const citedByDOI = await contract.getCitedByDOI(doi_reference);
        console.log(`Citações do DOI ${doi_reference}: ${citedByDOI}`);
    }
    catch (error) {
        console.error("Erro ao recuperar as citações:", error);
    }

    try {
        const citedByTitle = await contract.getCitedByTitle(title_reference);
        console.log(`Citações da publicação "${title_reference}": ${citedByTitle}`);
    }
    catch (error) {
        console.error("Erro ao recuperar as citações:", error);
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
    