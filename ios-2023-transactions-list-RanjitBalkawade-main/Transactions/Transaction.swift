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
    let creditDebitIndicatorValue: String
    let creationTimeValue: String
    let stateValue: String
    let transactionAmountCurrency: TransactionAmountCurrency
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case creditDebitIndicatorValue = "creditDebitIndicator"
        case creationTimeValue = "creationTime"
        case stateValue = "state"
        case transactionAmountCurrency
    }
}

// MARK: - TransactionAmountCurrency

struct TransactionAmountCurrency: Codable {
    let amount: String
    let currencyCode: String
}
