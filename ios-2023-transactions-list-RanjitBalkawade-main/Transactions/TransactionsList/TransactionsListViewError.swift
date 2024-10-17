//
//  TransactionsListViewError.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation

/// Enum representing possible errors that can occur while fetching the transactions list.
enum TransactionsListViewError: Error {
    
    /// Represents an unknown error.
    case unknown
    
    /// Represents the case where no transactions were found.
    case noTransactions
    
    /// Represents an error when there is no internet connection.
    case offline
    
    /// Provides a user-friendly description for each error case, which can be shown to the user.
    var description: String {
        switch self {
            case .unknown:
                return "Something went wrong, please try again later."
            case .noTransactions:
                return "No transactions found, please try again later."
            case .offline:
                return "No internet connection, please check your connection."
        }
    }
}
