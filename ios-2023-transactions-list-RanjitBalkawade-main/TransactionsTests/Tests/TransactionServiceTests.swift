//
//  TransactionServiceTests.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 18/10/2024.
//

import XCTest
import Combine
import BackbaseNetworking
@testable import Transactions

class TransactionServiceTests: XCTestCase {
    
    private var mockAPI: MockTransactionsAPI!
    private var service: TransactionService!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockTransactionsAPI()
        service = TransactionService(transactionsApi: mockAPI)
    }
    
    override func tearDown() {
        mockAPI = nil
        service = nil
        super.tearDown()
    }
    
    func testFetchTransactions_withSuccess() {
        
        let jsonData = MockHelper.loadJsonData(filename: "Transactions")
        mockAPI.result = .success(jsonData!)
        
        let expectation = self.expectation(description: "Fetch transactions successfully")
        
        service.fetchTransactions(userId: 1) { result in
            switch result {
                case .success(let fetchedTransactions):
                    XCTAssertEqual(fetchedTransactions.count, 5, "Expected to fetch 2 transactions")
                    XCTAssertEqual(fetchedTransactions[0].description, "Test1", "First transaction description should match")
                    XCTAssertEqual(fetchedTransactions[1].description, "Test2", "Second transaction description should match")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success, but got failure: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTransactions_withFailure() {
        mockAPI.result = .failure(BackbaseAPIError.unknown)

        let expectation = self.expectation(description: "Fetch transactions failed due to network error")
        
        service.fetchTransactions(userId: 1) { result in
            switch result {
                case .success:
                    XCTFail("Expected failure, but got success")
                case .failure(let error):
                    XCTAssertNotNil(error, "Expected a network error")
                    expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTransactions_withInvalidData() {
        let invalidJson = "Invalid JSON".data(using: .utf8)!
        mockAPI.result = .success(invalidJson)
        
        let expectation = self.expectation(description: "Fetch transactions failed due to invalid data")
        
        service.fetchTransactions(userId: 1) { result in
            switch result {
                case .success:
                    XCTFail("Expected failure due to invalid data")
                case .failure(let error):
                    XCTAssertNotNil(error, "Expected a decoding error")
                    expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

