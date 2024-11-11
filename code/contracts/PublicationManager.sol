// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract PublicationManager {
    // basic Publication struct    
    struct Publication {
        string doi;
        string title;
        string[] authors;
        string institution;
        string accessLink;
        uint[] citations;  // IDs of publications that this publication cites
        bool active;
    }

    // event to register Publications created
    event PublicationCreated(string doi, string title);

    // mapping to store Publications by id, and check if they exist
    mapping(string => Publication) private publications;

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
        string[] memory _authors,
        string memory _institution,
        string memory _accessLink,
        string[] memory _citations
    ) public publicationDoesNotExist(_doi) {
        require(_citations.length > 0, "A publication must have at least one citation.");
        
        // Check if all citations exist before create a publication
        for (uint i = 0; i < _citations.length; i++) {
            require(publications[_citations[i]].active, "All citations must exist.");
        }

        publications[_doi] = Publication(_doi, _title, _authors, _institution, _accessLink, _citations, true);
        emit PublicationCreated(_doi, _title);
    }

    function getTitleByDOI(string memory _doi) public view publicationExists(_doi) returns (string memory) {
        return publications[_doi].title;
    }

    function getCitationCount(string memory _doi) public view publicationExists(_doi) returns (uint) {
        return publications[_doi].citations.length;
    }

    function getPublicationByDOI(string memory _doi) public view publicationExists(_doi) returns (Publication memory) {
        return publications[_doi];
    }
}