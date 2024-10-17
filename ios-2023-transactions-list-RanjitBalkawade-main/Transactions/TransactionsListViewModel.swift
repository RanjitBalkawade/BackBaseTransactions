//
//  TransactionsListViewModel.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation
import Combine
import BackbaseNetworking

enum TransactionsListViewError: Error {
    case unknown
    case noTransactions
    case offline
    
    var description: String {
        switch self {
            case .unknown:
                return "Something went wrong, please try again later"
            case .noTransactions:
                return "No transactions found, please try again later."
            case .offline:
                return "No internet connection, please check your connection."
        }
    }
}

class TransactionsListViewModel {
    var pendingTransactions: [Transaction] = []
    var completedTransactions: [Transaction] = []
    
    var completedTransactionsCellViewModels: [TransactionCellViewModel] {
        getTransactionCellViewModels(
            groupedTransactions: getSortedGroupedTransactions(transactions: completedTransactions)
        )
    }
    
    var pendingTransactionsCellViewModels: [TransactionCellViewModel] {
        getTransactionCellViewModels(
            groupedTransactions: getSortedGroupedTransactions(transactions: pendingTransactions)
        )
    }
    
    struct GroupingKey: Hashable {
        let creditDebitIndicator: CreditDebitIndicator?
        let creationTimeWithoutTime: Date?
    }
    
    var title: String {
        "Transactions"
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func fetchTransactions(completion: @escaping (Result<Void, TransactionsListViewError>) -> Void) {
        TransactionsAPI().getTransactions(userId: 10015)
            .map { $0 }
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completionHandler in
                switch completionHandler {
                    case .failure(let error):
                        guard let backbaseAPIError = error as? BackbaseAPIError else {
                            completion(.failure(TransactionsListViewError.unknown))
                            return
                        }
                        
                        switch backbaseAPIError {
                            case .offline:
                                completion(.failure(TransactionsListViewError.offline))
                            default:
                                completion(.failure(TransactionsListViewError.unknown))
                        }
                        
                    case .finished:
                        break
                }
            }, receiveValue: { [weak self] transactions in
                
                guard transactions.isEmpty == false else {
                    completion(.failure(TransactionsListViewError.noTransactions))
                    return
                }
                
                self?.processData(transactions: transactions)
                completion(.success(()))
            })
            .store(in: &cancellables)
    }
    
    func processData(transactions: [Transaction]) {
        let tuple = getPendingAndCompletedTransactions(transactions: transactions)
        pendingTransactions = tuple.pending
        completedTransactions = tuple.completed
    }
    
    func getPendingAndCompletedTransactions(transactions: [Transaction]) -> (pending: [Transaction], completed: [Transaction]) {
        transactions.reduce(into: (pending: [Transaction](), completed: [Transaction]())) { result, transaction in
            if transaction.state == .pending {
                result.pending.append(transaction)
            } else if transaction.state == .completed {
                result.completed.append(transaction)
            }
        }
    }
    
    func getSortedGroupedTransactions(transactions: [Transaction]) -> [(key: GroupingKey, value: [Transaction])] {
        
        let groupedTransactions = Dictionary(grouping: transactions) { transaction in
            GroupingKey(creditDebitIndicator: transaction.creditDebitIndicator, creationTimeWithoutTime: transaction.creationTimeWithoutTime)
        }
        
        return groupedTransactions.sorted {
            if let creationTime1 = $0.key.creationTimeWithoutTime, let creationTime2 = $1.key.creationTimeWithoutTime {
                if creationTime1 != creationTime2 {
                    return creationTime1 < creationTime2
                }
            }
            
            if let creditDebitIndicator1 = $0.key.creditDebitIndicator, let creditDebitIndicator2 = $1.key.creditDebitIndicator {
                return creditDebitIndicator1.rawValue < creditDebitIndicator2.rawValue
            }
            
            return false
        }
    }
    
    
    func getTransactionCellViewModels(groupedTransactions: [(key: GroupingKey, value: [Transaction])]) -> [TransactionCellViewModel] {
        groupedTransactions.map { TransactionCellViewModel(transactions: $0.value) }
    }
    
}


extension Date {
    var withoutTime: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)
    }
}


private extension Transaction {
    var creationTimeWithoutTime: Date? {
        creationTime?.withoutTime
    }
}
