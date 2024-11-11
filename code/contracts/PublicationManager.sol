// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract PublicationManager {
    // basic Publication struct    
    struct Publication {
        string doi;
        string title;
        string[] authors;
        string institution;
        uint year;
        string[] references;  // IDs of publications that this publication cites
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
        uint _year,
        string[] memory _references
    ) public publicationDoesNotExist(_doi) {
        
        // Check if all references exist before create a publication
        for (uint i = 0; i < _references.length; i++) {
            require(publications[_references[i]].active, "Some reference does not exist.");
        }

        publications[_doi] = Publication({
            doi: _doi,
            title: _title,
            authors: _authors,
            institution: _institution,
            year: _year,
            active: true,
            references: _references
        });
        emit PublicationCreated(_doi, _title);
    }

    function getTitleByDOI(string memory _doi) public view publicationExists(_doi) returns (string memory) {
        return publications[_doi].title;
    }

    function getReferencesCount(string memory _doi) public view publicationExists(_doi) returns (uint) {
        return publications[_doi].references.length;
    }

    function getPublicationByDOI(string memory _doi) public view publicationExists(_doi) returns (Publication memory) {
        return publications[_doi];
    }
}