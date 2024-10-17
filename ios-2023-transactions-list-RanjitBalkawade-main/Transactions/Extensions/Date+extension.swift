//
//  Date+extension.swift
//  Transactions
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation

extension Date {
    
    /// A computed property that returns a new `Date` instance without the time component.
    var withoutTime: Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: components)
    }
}
