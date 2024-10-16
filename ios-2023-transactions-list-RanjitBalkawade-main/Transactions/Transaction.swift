//
//  Transaction.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 14/10/2024.
//

import Foundation

// MARK: - Transaction
struct Transaction: Codable {
    let id: String
    let description: String
    let creditDebitIndicator: String
    let creationTime: String
    let state: String
    let transactionAmountCurrency: TransactionAmountCurrency
}

// MARK: - TransactionAmountCurrency
struct TransactionAmountCurrency: Codable {
    let amount: String
    let currencyCode: String
}
