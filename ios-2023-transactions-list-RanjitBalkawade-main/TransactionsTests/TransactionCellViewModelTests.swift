//
//  TransactionCellViewModelTests.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import XCTest
import BackbaseMDS
@testable import Transactions

final class TransactionCellViewModelTests: XCTestCase {
    
    var viewModel: TransactionCellViewModel!
    var mockTransactions: [Transaction]!
    
    override func setUp() {
        super.setUp()
        
        let transaction1 = Transaction(
            id: "1",
            description: "Test Transaction 1",
            creditDebitIndicatorValue: "CRDT",
            creationTimeValue: "2019-05-15T14:28:01",
            stateValue: "COMPLETED",
            transactionAmountCurrency: TransactionAmountCurrency(amount: "100.50", currencyCode: "EUR")
        )
        
        let transaction2 = Transaction(
            id: "2",
            description: "Test Transaction 2",
            creditDebitIndicatorValue: "CRDT",
            creationTimeValue: "2019-05-15T14:28:01",
            stateValue: "COMPLETED",
            transactionAmountCurrency: TransactionAmountCurrency(amount: "200.75", currencyCode: "EUR")
        )
        
        mockTransactions = [transaction1, transaction2]
        viewModel = TransactionCellViewModel(transactions: mockTransactions)
    }
    
    override func tearDown() {
        viewModel = nil
        mockTransactions = nil
        super.tearDown()
    }
    
    func testTransactionCount() {
        XCTAssertEqual(viewModel.transactionCount, "2 Credit", "Transaction count should be correctly formatted.")
    }
    
    func testDescription() {
        let expectedDescription = "Test Transaction 1\nTest Transaction 2"
        XCTAssertEqual(viewModel.description, expectedDescription, "Description should be joined by newline.")
    }
    
    func testAmountColor() {
        XCTAssertEqual(viewModel.amountColor, BackbaseUI.shared.colors.success, "Amount color should match the credit indicator color.")
    }
    
    func testIcon() {
        let expectedIcon = UIImage(named: "transaction_credit")
        XCTAssertEqual(viewModel.icon, expectedIcon, "Icon should match the credit transaction icon.")
    }
    
    func testTitle() {
        XCTAssertEqual(viewModel.title, "Completed", "Title should match the state of the first transaction.")
    }
    
    func testDate() {
        let expectedDate = viewModel.date
        XCTAssertEqual(expectedDate, "Wednesday, May 15, 2019", "Date should match the format of the first transaction.")
    }
    
    func testAmount() {
        let expectedAmount = "+€ 301,25"
        XCTAssertEqual(viewModel.amount, expectedAmount, "Amount should be correctly formatted with the annotation and sum.")
    }
}


