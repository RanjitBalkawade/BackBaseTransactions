//
//  TransactionCellViewModel.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import UIKit
import BackbaseMDS

/// The view model for displaying a group of transactions in a table view cell.
class TransactionCellViewModel {
    
    //MARK: - Internal properties
    
    /// Returns the count of transactions along with the credit/debit text.
    var transactionCount: String {
        let str = ["\(transactions.count)", transactions.first?.creditDebitIndicator?.text]
        return str.compactMap { $0 }.joined(separator: " ")
    }
    
    /// Returns the descriptions of all transactions, joined by a new line.
    var description: String {
        transactions.map(\.description).joined(separator: "\n")
    }
    
    /// Returns the color of the amount text based on the credit or debit status of the transaction.
    var amountColor: UIColor {
        transactions.first?.creditDebitIndicator?.textColor ?? BackbaseUI.shared.colors.textDefault
    }
    
    /// Returns the icon associated with the credit or debit status of the transaction.
    var icon: UIImage? {
        transactions.first?.creditDebitIndicator?.icon
    }
    
    /// Returns the title based on the state of the first transaction..
    var title: String? {
        transactions.first?.state?.title
    }
    
    /// Returns the formatted date of the first transaction in the list.
    var date: String? {
        guard let date = transactions.first?.creationTime else {
            return nil
        }
        return Self.dateFormatter.string(from: date)
    }
    
    /// Returns the formatted total amount of the grouped transactions with a "+" or "-" annotation for credit or debit.
    var amount: String? {
        Self.currencyFormatter.currencyCode = transactions.first?.transactionAmountCurrency.currencyCode
        let finalAmount = transactions.compactMap { Double($0.transactionAmountCurrency.amount) }.reduce(0, +)
        
        guard
            let annotation = transactions.first?.creditDebitIndicator?.annotation,
            let formattedAmount = Self.currencyFormatter.string(from: NSNumber(value: finalAmount)) else {
            return nil
        }
        return annotation + formattedAmount
    }
    
    //MARK: - Private properties
    
    /// Currency formatter to format the transaction amounts.
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    /// Date formatter to format the transaction dates.
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    /// Array of transactions associated with this view model.
    private let transactions: [Transaction]
    
    //MARK: - Initializer
    
    /// Initializes the view model with a list of transactions.
    /// - Parameter transactions: The list of transactions to be displayed in the cell.
    init(transactions: [Transaction]) {
        self.transactions = transactions
    }
}

//MARK: - Helper extensions

private extension CreditDebitIndicator {
    
    /// Returns a text representation for the credit or debit status.
    var text: String {
        switch self {
            case .credit:
                return "Credit"
            case .debit:
                return "Debit"
        }
    }
    
    /// Returns the annotation "+" for credit or "-" for debit to be used in the amount string.
    var annotation: String {
        switch self {
            case .credit:
                return "+"
            case .debit:
                return "-"
        }
    }
    
    /// Returns the associated icon for credit or debit transactions.
    var icon: UIImage? {
        switch self {
            case .credit:
                return UIImage(named: "transaction_credit")
            case .debit:
                return UIImage(named: "transaction_debit")
        }
    }
    
    /// Returns the text color for the transaction amount based on the status.
    var textColor: UIColor {
        switch self {
            case .credit:
                return BackbaseUI.shared.colors.success
            case .debit:
                return BackbaseUI.shared.colors.textDefault
        }
    }
}

private extension TransactionState {
    
    /// Returns the title based on the transaction state.
    var title: String {
        switch self {
            case .pending:
                return "Pending"
            case .completed:
                return "Completed"
        }
    }
}
