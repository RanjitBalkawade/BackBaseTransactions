//
//  TransactionsListViewModelTests.swift
//  TransactionsTests
//
//  Created by Aleksander Prenga on 29/12/2022.
//

import XCTest
import BackbaseNetworking
@testable import Transactions

final class TransactionsListViewModelTests: XCTestCase {
    
    private var viewModel: TransactionsListViewModel!
    private var mockAPI: MockTransactionsAPI!
    private var mockData: Data!
    
    override func setUp() {
        super.setUp()
        mockAPI = MockTransactionsAPI()
        mockData = MockHelper.loadJsonData(filename: "Transactions")!
        viewModel = TransactionsListViewModel(userId: 0, transactionsApi: mockAPI)
    }
    
    override func tearDown() {
        mockAPI = nil
        mockData = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchTransactions_withSuccess() {
        mockAPI.result = .success(mockData)
        
        let expectation = self.expectation(description: "Transactions fetched successfully")
        
        viewModel.fetchTransactions { result in
            switch result {
                case .success:
                    XCTAssertFalse(self.viewModel.numberOfSections() == 0, "Transaction cell view models should not be empty.")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success, but got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTransactions_withFailure() {
        mockAPI.result = .failure(BackbaseAPIError.offline)
        
        let expectation = self.expectation(description: "Fetching transactions failed")
        
        viewModel.fetchTransactions { result in
            switch result {
                case .success:
                    XCTFail("Expected failure, but got success.")
                case .failure(let error):
                    XCTAssertEqual(error, TransactionsListViewError.offline, "Expected offline error.")
                    expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchTransactions_withNoTransactions() {
        let emptyData = "[]".data(using: .utf8)!
        mockAPI.result = .success(emptyData)
        
        let expectation = self.expectation(description: "Fetching transactions returned no data")
        
        viewModel.fetchTransactions { result in
            switch result {
                case .success:
                    XCTFail("Expected no transactions error, but got success.")
                case .failure(let error):
                    XCTAssertEqual(error, TransactionsListViewError.noTransactions, "Expected noTransactions error.")
                    expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTitleForSection() {
        mockAPI.result = .success(mockData)
        
        let expectation = self.expectation(description: "Fetched transactions and checked section titles")
        
        viewModel.fetchTransactions { result in
            switch result {
                case .success:
                    XCTAssertEqual(self.viewModel.titleForSection(0), "Pending", "Expected 'Pending' as section title.")
                    XCTAssertEqual(self.viewModel.titleForSection(1), "Completed", "Expected 'Completed' as section title.")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success, but got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNumberOfSections() {
        mockAPI.result = .success(mockData)
        
        let expectation = self.expectation(description: "Fetched transactions and checked number of sections")
        
        viewModel.fetchTransactions { result in
            switch result {
                case .success:
                    let sectionCount = self.viewModel.numberOfSections()
                    XCTAssertEqual(sectionCount, 2, "Expected 2 sections.")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success, but got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNumberOfItemsInSection() {
        mockAPI.result = .success(mockData)
        
        let expectation = self.expectation(description: "Fetched transactions and checked number of items in sections")
        
        viewModel.fetchTransactions { result in
            switch result {
                case .success:
                    XCTAssertEqual(self.viewModel.numberOfItems(inSection: 0), 1, "Expected 1 item in the first section.")
                    XCTAssertEqual(self.viewModel.numberOfItems(inSection: 1), 3, "Expected 3 item in the second section.")
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success, but got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testTransactionCellViewModelForIndexPath() {
        mockAPI.result = .success(mockData)
        
        let expectation = self.expectation(description: "Fetched transactions and checked cell view model for index path")
        
        viewModel.fetchTransactions { result in
            switch result {
                case .success:
                    let indexPath1 = IndexPath(row: 0, section: 0)
                    let cellViewModel1 = self.viewModel.transactionCellViewModel(forIndexPath: indexPath1)
                    XCTAssertEqual(cellViewModel1.description, "Test1", "Expected the description to be 'Test1'")
                    
                    let indexPath2 = IndexPath(row: 0, section: 1)
                    let cellViewModel2 = self.viewModel.transactionCellViewModel(forIndexPath: indexPath2)
                    XCTAssertEqual(cellViewModel2.description, "Test4", "Expected the description to be 'Test4'")
                    
                    let indexPath3 = IndexPath(row: 1, section: 1)
                    let cellViewModel3 = self.viewModel.transactionCellViewModel(forIndexPath: indexPath3)
                    XCTAssertEqual(cellViewModel3.description, "Test5", "Expected the description to be 'Test5'")
                    XCTAssertEqual(cellViewModel3.transactionCount, "1 Debit", "Expected the description to be '1 Debit'")
                    
                    let indexPath4 = IndexPath(row: 2, section: 1)
                    let cellViewModel4 = self.viewModel.transactionCellViewModel(forIndexPath: indexPath4)
                    XCTAssertEqual(cellViewModel4.description, "Test2\nTest3", "Expected the description to be 'Test2\nTest3'")
                    
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success, but got error: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
