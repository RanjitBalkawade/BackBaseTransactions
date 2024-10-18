//
//  TransactionService.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 18/10/2024.
//

import Combine
import BackbaseNetworking

/// Service responsible for fetching transactions from the API.
class TransactionService: TransactionServiceProtocol {
    
    private var transactionsApi: TransactionsAPIProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    /// Initializes the service with the API protocol.
    /// - Parameter transactionsApi: The API protocol for fetching transactions.
    init(transactionsApi: TransactionsAPIProtocol = TransactionsAPI()) {
        self.transactionsApi = transactionsApi
    }
    
    /// Fetches transactions for a given user.
    /// - Parameters:
    ///   - userId: The ID of the user for whom to fetch transactions.
    ///   - completion: Completion handler returning either success or failure with an error.
    func fetchTransactions(userId: Int, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        transactionsApi.getTransactions(userId: userId)
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completionHandler in
                    switch completionHandler {
                        case .failure(let error):
                            completion(.failure(error))
                        case .finished:
                            break
                    }
                },
                receiveValue: { transactions in
                    completion(.success(transactions))
                }
            )
            .store(in: &cancellables)
    }
}
