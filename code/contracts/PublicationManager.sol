// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract PublicationManager {
    // basic Publication struct    
    struct Publication {
        string doi;
        string title;
        string[] references;  // DOIs das publicações referenciadas
        bool active;
    }

    // event to register Publications created
    event PublicationCreated(string doi, string title);

    // mapping to store Publications by id, and check if they exist
    mapping(string => Publication) private publications;
    mapping(string => string) private titleToDoi;

    mapping(string => string[]) private citedBy;

    modifier publicationExists(string memory _doi) {
        require(publications[_doi].active, "Publication does not exist.");
        _;
    }

    modifier publicationDoesNotExist(string memory _doi) {
        require(!publications[_doi].active, "Publication already exists.");
        _;
    }


    function createPublication(
        string memory _doi,
        string memory _title,
        string[] memory _references
    ) public publicationDoesNotExist(_doi) {
        
        // Check if all references exist before create a publication
        for (uint i = 0; i < _references.length; i++) {
            if (!publications[_references[i]].active) {
                revert(string(abi.encodePacked("Referenced DOI does not exist: ", _references[i])));
            }
        }

        publications[_doi] = Publication({
            doi: _doi,
            title: _title,
            active: true,
            references: _references
        });
        
        titleToDoi[_title] = _doi;

        for (uint i = 0; i < _references.length; i++) {
            citedBy[_references[i]].push(_doi);
        }

        emit PublicationCreated(_doi, _title);
    }

    function getTitleByDOI(string memory _doi) public view publicationExists(_doi) returns (string memory) {
        return publications[_doi].title;
    }

    function getDOIByTitle(string memory _title) public view returns (string memory) {
        string memory doi = titleToDoi[_title];
        require(publications[doi].active, "Publication does not exist.");
        return doi;
    }

    function getReferencesByDOI(string memory _doi) public view publicationExists(_doi) returns (string[] memory) {
        return publications[_doi].references;
    }

    function getReferencesByTitle(string memory _title) public view returns (string[] memory) {
        string memory doi = titleToDoi[_title];
        require(publications[doi].active, "Publication does not exist.");
        return publications[doi].references;
    }

    function getCitedByDOI(string memory _doi) public view publicationExists(_doi) returns (string[] memory) {
        return citedBy[_doi];
    }

    function getCitedByTitle(string memory _title) public view returns (string[] memory) {
        string memory doi = titleToDoi[_title];
        require(publications[doi].active, "Publication does not exist.");
        return citedBy[doi];
    }
}