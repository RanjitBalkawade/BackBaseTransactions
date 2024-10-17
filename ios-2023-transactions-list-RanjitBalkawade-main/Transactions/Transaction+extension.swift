//
//  Transaction+extension.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation

extension Transaction {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
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
        Self.dateFormatter.date(from: creationTimeValue)
    }
    
    var creationTimeWithoutTime: Date? {
        creationTime?.withoutTime
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
