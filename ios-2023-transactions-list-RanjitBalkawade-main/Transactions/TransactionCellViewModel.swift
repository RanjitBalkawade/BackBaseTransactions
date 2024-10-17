//
//  TransactionCellViewModel.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import UIKit
import BackbaseMDS

class TransactionCellViewModel {
    
    //MARK: - Internal properties
    
    var transactionCount: String {
        let str = ["\(transactions.count)", transactions.first?.creditDebitIndicator?.text]
        return str.compactMap{ $0 }.joined(separator: " ")
    }
    
    var description: String {
        transactions.map(\.description).joined(separator: "\n")
    }
    
    var amountColor: UIColor {
        transactions.first?.creditDebitIndicator?.textColor ?? BackbaseUI.shared.colors.textDefault
    }
    
    var icon: UIImage? {
        transactions.first?.creditDebitIndicator?.icon
    }
    
    var title: String? {
        transactions.first?.state?.title
    }
    
    var date: String? {
        guard let date = transactions.first?.creationTime else {
            return nil
        }
        return Self.dateFormatter.string(from: date)
    }
    
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
    
    private static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    private let transactions: [Transaction]
    
    //MARK: - Initializer
    
    init (transactions: [Transaction]) {
        self.transactions = transactions
    }
}

//MARK: - Helper extensions

private extension CreditDebitIndicator {
    var text: String {
        switch self {
            case .credit:
                return "Credit"
            case .debit:
                return "Debit"
        }
    }
    
    var annotation: String {
        switch self {
            case .credit:
                return "+"
            case .debit:
                return "-"
        }
    }
    
    var icon: UIImage? {
        switch self {
            case .credit:
                return UIImage(named: "transaction_credit")
            case .debit:
                return UIImage(named: "transaction_debit")
        }
    }
    
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
    
    var title: String {
        switch self {
            case .pending:
                return "Pending"
            case .completed:
                return "Completed"
        }
    }
}


