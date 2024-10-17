//
//  Transaction.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 14/10/2024.
//

import Foundation

// MARK: - Transaction

/// Represents a transaction, which includes details such as the ID, description, state, transaction amount, etc.
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
    
    init(
        id: String,
        description: String,
        creditDebitIndicatorValue: String,
        creationTimeValue: String,
        stateValue: String,
        transactionAmountCurrency: TransactionAmountCurrency
    ) {
        self.id = id
        self.description = description
        self.creditDebitIndicatorValue = creditDebitIndicatorValue
        self.creationTimeValue = creationTimeValue
        self.stateValue = stateValue
        self.transactionAmountCurrency = transactionAmountCurrency
    }
}

// MARK: - TransactionAmountCurrency

struct TransactionAmountCurrency: Codable {
    let amount: String
    let currencyCode: String
    
    init(amount: String, currencyCode: String) {
        self.amount = amount
        self.currencyCode = currencyCode
    }
}

// MARK: - TransactionState

enum TransactionState: String, Codable {
    case pending = "PENDING"
    case completed = "COMPLETED"
}

// MARK: - CreditDebitIndicator

enum CreditDebitIndicator: String, Codable {
    case credit = "CRDT"
    case debit = "DBIT"
}
