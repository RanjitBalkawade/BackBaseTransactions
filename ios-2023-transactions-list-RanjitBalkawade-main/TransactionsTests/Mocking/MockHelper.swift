//
//  MockHelper.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation
@testable import Transactions
/// Helper class for mocking data.
class MockHelper {
    
    /// Array of transactions
    static let mockTransactions = [
        Transaction(
            id: "1",
            description: "Test1",
            creditDebitIndicatorValue: "CRDT",
            creationTimeValue: "2019-05-15T14:28:01",
            stateValue: "PENDING",
            transactionAmountCurrency: TransactionAmountCurrency(amount: "1919.95", currencyCode: "EUR")
        ),
        Transaction(
            id: "2",
            description: "Test2",
            creditDebitIndicatorValue: "CRDT",
            creationTimeValue: "2019-05-15T14:28:01",
            stateValue: "COMPLETED",
            transactionAmountCurrency: TransactionAmountCurrency(amount: "1919.95", currencyCode: "USD")
        ),
        Transaction(
            id: "3",
            description: "Test3",
            creditDebitIndicatorValue: "CRDT",
            creationTimeValue: "2019-05-15T14:28:01",
            stateValue: "COMPLETED",
            transactionAmountCurrency: TransactionAmountCurrency(amount: "1919.95", currencyCode: "GBP")
        ),
        Transaction(
            id: "4",
            description: "Test4",
            creditDebitIndicatorValue: "CRDT",
            creationTimeValue: "2019-05-16T11:20:00",
            stateValue: "COMPLETED",
            transactionAmountCurrency: TransactionAmountCurrency(amount: "1919.95", currencyCode: "EUR")
        ),
        Transaction(
            id: "5",
            description: "Test5",
            creditDebitIndicatorValue: "DBIT",
            creationTimeValue: "2019-05-16T11:20:00",
            stateValue: "COMPLETED",
            transactionAmountCurrency: TransactionAmountCurrency(amount: "1919.95", currencyCode: "EUR")
        )
    ]
    
    /// Loads JSON data from a file in bundle with the given filename.
    static func loadJsonData(filename: String) -> Data? {
        let fileURL = Bundle(for: MockHelper.self).url(forResource: filename, withExtension: "json")
        return try? Data(contentsOf: fileURL!)
    }
}
