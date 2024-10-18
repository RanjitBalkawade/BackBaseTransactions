//
//  TransactionServiceProtocol.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 18/10/2024.
//

import Foundation

/// Protocol defining the methods for mocking `TransactionService`
protocol TransactionServiceProtocol {
    func fetchTransactions(userId: Int, completion: @escaping (Result<[Transaction], Error>) -> Void)
}
