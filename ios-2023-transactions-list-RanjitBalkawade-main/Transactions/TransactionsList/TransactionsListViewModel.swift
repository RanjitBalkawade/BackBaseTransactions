//
//  TransactionsListViewModel.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation
import Combine
import BackbaseNetworking

protocol TransactionsAPIProtocol {
    func getTransactions(userId: Int) -> AnyPublisher<Data, BackbaseNetworking.BackbaseAPIError>
}

extension TransactionsAPI: TransactionsAPIProtocol {}

class TransactionsListViewModel {
    
    //MARK: - Internal properties
    
    var title: String {
        "Transactions"
    }
    
    //MARK: - Private properties
    
    private var transactionCellViewModels: [[TransactionCellViewModel]] {
        [getCellViewModels(for: pendingTransactions), getCellViewModels(for: completedTransactions)].filter { $0.isEmpty == false }
    }
    
    private var pendingTransactions: [Transaction] = []
    private var completedTransactions: [Transaction] = []
    private var cancellables: Set<AnyCancellable> = []
    
    private let userId: Int
    private var transactionsApi: TransactionsAPIProtocol
    
    init(userId: Int, transactionsApi: TransactionsAPIProtocol = TransactionsAPI()) {
        self.userId = userId
        self.transactionsApi = transactionsApi
    }
    
    //MARK: - Internal methods
    
    func fetchTransactions(completion: @escaping (Result<Void, TransactionsListViewError>) -> Void) {
        transactionsApi.getTransactions(userId: userId)
            .decode(type: [Transaction].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completionHandler in
                self?.handleCompletion(completionHandler, completion: completion)
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
    
    func titleForSection(_ section: Int) -> String? {
        transactionCellViewModels[section].first?.title
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        transactionCellViewModels[section].count
    }
    
    func numberOfSections() -> Int {
        transactionCellViewModels.count
    }
    
    func transactionCellViewModel(forIndexPath indexPath: IndexPath) -> TransactionCellViewModel {
        transactionCellViewModels[indexPath.section][indexPath.row]
    }
    
    //MARK: - Private methods
    
    private func processData(transactions: [Transaction]) {
        let tuple = getPendingAndCompletedTransactions(transactions: transactions)
        pendingTransactions = tuple.pending
        completedTransactions = tuple.completed
    }
    
    private func handleCompletion(_ completionHandler: Subscribers.Completion<Error>, completion: @escaping (Result<Void, TransactionsListViewError>) -> Void) {
        switch completionHandler {
            case .failure(let error):
                completion(.failure(self.mapAPIErrorToViewError(error)))
            case .finished:
                break
        }
    }
    
    // Map BackbaseAPIError to TransactionsListViewError
    private func mapAPIErrorToViewError(_ error: Error) -> TransactionsListViewError {
        guard let backbaseAPIError = error as? BackbaseAPIError else {
            return .unknown
        }
        
        switch backbaseAPIError {
            case .offline:
                return .offline
            default:
                return .unknown
        }
    }
    
    private func getPendingAndCompletedTransactions(transactions: [Transaction]) -> (pending: [Transaction], completed: [Transaction]) {
        let result = (pending: [Transaction](), completed: [Transaction]())
        
        return transactions.reduce(into: result) { result, transaction in
            if transaction.state == .pending {
                result.pending.append(transaction)
            } else if transaction.state == .completed {
                result.completed.append(transaction)
            }
        }
    }
    
    private func getSortedGroupedTransactions(transactions: [Transaction]) -> [(key: GroupingKey, value: [Transaction])] {
        
        let groupedTransactions = Dictionary(grouping: transactions) { transaction in
            GroupingKey(creditDebitIndicator: transaction.creditDebitIndicator, creationTimeWithoutTime: transaction.creationTimeWithoutTime)
        }
        
        return groupedTransactions.sorted {
            if let creationTime1 = $0.key.creationTimeWithoutTime, let creationTime2 = $1.key.creationTimeWithoutTime {
                if creationTime1 != creationTime2 {
                    return creationTime1 > creationTime2
                }
            }
            
            if let creditDebitIndicator1 = $0.key.creditDebitIndicator, let creditDebitIndicator2 = $1.key.creditDebitIndicator {
                return creditDebitIndicator1.rawValue < creditDebitIndicator2.rawValue
            }
            
            return false
        }
    }
    
    private func getTransactionCellViewModels(groupedTransactions: [(key: GroupingKey, value: [Transaction])]) -> [TransactionCellViewModel] {
        groupedTransactions.map { TransactionCellViewModel(transactions: $0.value) }
    }
    
    private func getCellViewModels(for transactions: [Transaction]) -> [TransactionCellViewModel] {
        let groupedTransactions = getSortedGroupedTransactions(transactions: transactions)
        return getTransactionCellViewModels(groupedTransactions: groupedTransactions)
    }
}

//MARK: - Helper Types

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

private struct GroupingKey: Hashable {
    let creditDebitIndicator: CreditDebitIndicator?
    let creationTimeWithoutTime: Date?
}

