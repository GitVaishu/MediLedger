// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MediLedger {

    // Admin (Drug Regulator)
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    // Medicine Batch Structure
    struct Batch {
        string batchId;
        string medicineName;
        uint manufactureDate;
        uint expiryDate;
        address manufacturer;
        bool recalled;
    }

    // Storage
    mapping(string => Batch) public batches;

    // Approved Manufacturers
    mapping(address => bool) public approvedManufacturers;

    // Events
    event ManufacturerApproved(address manufacturer);
    event BatchRegistered(
        string batchId,
        string medicineName,
        address manufacturer
    );
    event BatchRecalled(string batchId);

    // Modifiers

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    modifier onlyManufacturer() {
        require(
            approvedManufacturers[msg.sender],
            "Not approved manufacturer"
        );
        _;
    }

    // Admin approves a manufacturer
    function approveManufacturer(address manufacturer)
        public
        onlyAdmin
    {
        approvedManufacturers[manufacturer] = true;

        emit ManufacturerApproved(manufacturer);
    }

    // Manufacturer registers a medicine batch
    function registerBatch(
        string memory _batchId,
        string memory _medicineName,
        uint _manufactureDate,
        uint _expiryDate
    )
        public
        onlyManufacturer
    {

        // Prevent duplicate batches
        require(
            bytes(batches[_batchId].batchId).length == 0,
            "Batch already exists"
        );

        batches[_batchId] = Batch(
            _batchId,
            _medicineName,
            _manufactureDate,
            _expiryDate,
            msg.sender,
            false
        );

        emit BatchRegistered(
            _batchId,
            _medicineName,
            msg.sender
        );
    }

    // Manufacturer can recall their batch
    function recallBatch(string memory _batchId)
        public
    {
        require(
            batches[_batchId].manufacturer == msg.sender,
            "Not batch owner"
        );

        batches[_batchId].recalled = true;

        emit BatchRecalled(_batchId);
    }

    // Public verification function
    function verifyBatch(string memory _batchId)
        public
        view
        returns (
            string memory batchId,
            string memory medicineName,
            uint manufactureDate,
            uint expiryDate,
            address manufacturer,
            bool recalled
        )
    {

        Batch memory b = batches[_batchId];

        return (
            b.batchId,
            b.medicineName,
            b.manufactureDate,
            b.expiryDate,
            b.manufacturer,
            b.recalled
        );
    }

}