//
//  MockTransactionService.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 18/10/2024.
//

import Combine
import BackbaseNetworking
@testable import Transactions

class MockTransactionService: TransactionServiceProtocol {
    
    // Result to simulate success or failure responses
    var result: Result<[Transaction], Error>?
    
    // Mocked fetchTransactions method
    func fetchTransactions(userId: Int, completion: @escaping (Result<[Transaction], Error>) -> Void) {
        // Check if a result is set, otherwise return a failure by default
        guard let result = result else {
            return completion(.failure(BackbaseAPIError.unknown))
        }
        
        // Call the completion with either success or failure based on the result set
        switch result {
            case .success(let transactions):
                completion(.success(transactions))
            case .failure(let error):
                completion(.failure(error))
        }
    }
}
