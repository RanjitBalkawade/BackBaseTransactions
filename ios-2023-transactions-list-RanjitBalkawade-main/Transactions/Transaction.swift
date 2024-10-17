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

extension Transaction {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        //dateFormatter.locale = Locale.current
        dateFormatter.locale = Locale(identifier: "nl_NL")
        return dateFormatter
    }()
    
    var state: TransactionState? {
        TransactionState(rawValue: stateValue)
    }
    
    var creditDebitIndicator: CreditDebitIndicator? {
        CreditDebitIndicator(rawValue: creditDebitIndicatorValue)
    }
    
    var creationTime: Date? {
        return Self.dateFormatter.date(from: creationTimeValue)
    }
}

enum TransactionState: String, Codable {
    case pending = "PENDING"
    case completed = "COMPLETED"
}

enum CreditDebitIndicator: String, Codable {
    case credit = "CRDT"
    case debit = "DBIT"
}
