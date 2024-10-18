//
//  TransactionsListViewModel.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation
import Combine
import BackbaseNetworking

/// ViewModel that handles the logic for displaying transactions in the transactions list view.
class TransactionsListViewModel {
    
    //MARK: - Internal properties
    
    /// The title for the transactions list view
    var title: String {
        "Transactions"
    }
    
    //MARK: - Private properties
    
    /// Collection of view models for transaction cells, grouped by pending and completed transactions.
    private var transactionCellViewModels: [[TransactionCellViewModel]] {
        [
            getCellViewModels(for: pendingTransactions),
            getCellViewModels(for: completedTransactions)
        ].filter { $0.isEmpty == false }
    }
    
    /// Transactions that are still pending.
    private var pendingTransactions: [Transaction] = []
    
    /// Transactions that have been completed.
    private var completedTransactions: [Transaction] = []
    
    /// Set of cancellables for managing Combine subscriptions.
    private var cancellables: Set<AnyCancellable> = []
    
    /// User ID used to fetch transactions for the given user.
    private let userId: Int
    
    /// API service for fetching transactions data.
    private let transactionService: TransactionServiceProtocol
    
    /// Initializes the view model with a given user ID and transaction service.
    /// - Parameters:
    ///   - userId: The ID of the user for whom transactions are fetched.
    ///   - transactionService: The service for fetching transactions.
    init(userId: Int, transactionService: TransactionServiceProtocol = TransactionService()) {
        self.userId = userId
        self.transactionService = transactionService
    }
    
    //MARK: - Internal methods
    
    /// Fetches transactions and processes the response.
    /// - Parameters:
    ///   - completion: Completion handler returning either success or failure with an error.
    func fetchTransactions(completion: @escaping (Result<Void, TransactionsListViewError>) -> Void) {
        transactionService.fetchTransactions(userId: userId) { [weak self] result in
            switch result {
                case .success(let transactions):
                    guard !transactions.isEmpty else {
                        completion(.failure(TransactionsListViewError.noTransactions))
                        return
                    }
                    self?.processData(transactions: transactions)
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(self?.mapAPIErrorToViewError(error) ?? .unknown))
            }
        }
    }
    
    /// Returns the title for a specific section in the table view.
    func titleForSection(_ section: Int) -> String? {
        transactionCellViewModels[section].first?.title
    }
    
    /// Returns the number of items in a given section.
    func numberOfItems(inSection section: Int) -> Int {
        transactionCellViewModels[section].count
    }
    
    /// Returns the number of sections in the table view, corresponding to transaction groups.
    func numberOfSections() -> Int {
        transactionCellViewModels.count
    }
    
    /// Returns the `TransactionCellViewModel` for the given index path.
    func transactionCellViewModel(forIndexPath indexPath: IndexPath) -> TransactionCellViewModel {
        transactionCellViewModels[indexPath.section][indexPath.row]
    }
    
    //MARK: - Private methods
    
    /// Processes the transactions by dividing them into pending and completed groups.
    private func processData(transactions: [Transaction]) {
        let tuple = getPendingAndCompletedTransactions(transactions: transactions)
        pendingTransactions = tuple.pending
        completedTransactions = tuple.completed
    }
    
    /// Handles the completion of a network call, mapping any errors and triggering completion handlers.
    /// - Parameters:
    ///   - completionHandler: The completion handler from the network request.
    ///   - completion: The completion handler passed in the method call.
    private func handleCompletion(_ completionHandler: Subscribers.Completion<Error>, completion: @escaping (Result<Void, TransactionsListViewError>) -> Void) {
        switch completionHandler {
            case .failure(let error):
                completion(.failure(self.mapAPIErrorToViewError(error)))
            case .finished:
                break
        }
    }
    
    /// Maps an API error to a `TransactionsListViewError`.
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
    
    /// Separates transactions into pending and completed groups.
    /// - Parameter transactions: The list of transactions to be grouped.
    /// - Returns: A tuple containing pending and completed transactions.
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
    
    /// Groups and sorts transactions by date and credit/debit indicator.
    /// - Parameter transactions: The list of transactions to be grouped.
    /// - Returns: A sorted array of grouped transactions.
    private func getSortedGroupedTransactions(transactions: [Transaction]) -> [(key: GroupingKey, value: [Transaction])] {
        
        let groupedTransactions = Dictionary(grouping: transactions) { transaction in
            GroupingKey(creditDebitIndicator: transaction.creditDebitIndicator, creationTimeWithoutTime: transaction.creationTimeWithoutTime)
        }
        
        return groupedTransactions.sorted {
            if
                let creationTime1 = $0.key.creationTimeWithoutTime,
                let creationTime2 = $1.key.creationTimeWithoutTime,
                creationTime1 != creationTime2 {
                return creationTime1 > creationTime2
            }
            
            if let creditDebitIndicator1 = $0.key.creditDebitIndicator, let creditDebitIndicator2 = $1.key.creditDebitIndicator {
                return creditDebitIndicator1.rawValue < creditDebitIndicator2.rawValue
            }
            
            return false
        }
    }
    
    /// Converts transactions into cell view models for display.
    /// - Parameter transactions: The list of transactions.
    /// - Returns: An array of `TransactionCellViewModel` for displaying in the UI.
    private func getCellViewModels(for transactions: [Transaction]) -> [TransactionCellViewModel] {
        getSortedGroupedTransactions(transactions: transactions).map { TransactionCellViewModel(transactions: $0.value) }
    }
    
}

//MARK: - Helper Types

/// A key used for grouping transactions.
struct GroupingKey: Hashable {
    let creditDebitIndicator: CreditDebitIndicator?
    let creationTimeWithoutTime: Date?
}
