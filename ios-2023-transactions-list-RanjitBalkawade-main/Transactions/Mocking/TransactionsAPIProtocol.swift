//
//  TransactionsAPIProtocol.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation
import Combine
import BackbaseNetworking

/// Protocol defining the methods for mocking `TransactionsAPI`
protocol TransactionsAPIProtocol {
    func getTransactions(userId: Int) -> AnyPublisher<Data, BackbaseNetworking.BackbaseAPIError>
}

/// Extends the `TransactionsAPI` class to conform to the `TransactionsAPIProtocol` protocol.
extension TransactionsAPI: TransactionsAPIProtocol {}
