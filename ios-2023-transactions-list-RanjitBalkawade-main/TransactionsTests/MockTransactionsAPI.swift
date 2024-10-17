//
//  MockTransactionsAPI.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import XCTest
import Combine
import BackbaseNetworking
@testable import Transactions

// Mock version of the TransactionsAPI class
class MockTransactionsAPI: TransactionsAPIProtocol {
    
    var result: Result<Data, BackbaseAPIError>?
    
    func getTransactions(userId: Int) -> AnyPublisher<Data, BackbaseAPIError> {
        guard let result = result else {
            return Empty<Data, BackbaseAPIError>()
                .eraseToAnyPublisher()
        }
        
        switch result {
            case .success(let data):
                return Just(data)
                    .setFailureType(to: BackbaseAPIError.self)
                    .eraseToAnyPublisher()
                
            case .failure(let error):
                return Fail(error: error)
                    .eraseToAnyPublisher()
        }
    }
}

