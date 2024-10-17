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
    
    /// Returns the transaction state as a `TransactionState` enum by converting the `stateValue` string.
    var state: TransactionState? {
        TransactionState(rawValue: stateValue)
    }
    
    /// Returns the credit or debit indicator as a `CreditDebitIndicator` enum by converting the `creditDebitIndicatorValue` string.
    var creditDebitIndicator: CreditDebitIndicator? {
        CreditDebitIndicator(rawValue: creditDebitIndicatorValue)
    }
    
    /// Converts the `creationTimeValue` string into a `Date` object.
    var creationTime: Date? {
        Self.dateFormatter.date(from: creationTimeValue)
    }
    
    /// Returns the `creationTime` without the time component.
    var creationTimeWithoutTime: Date? {
        creationTime?.withoutTime
    }
}
