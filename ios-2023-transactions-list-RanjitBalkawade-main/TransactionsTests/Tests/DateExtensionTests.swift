//
//  DateExtensionTests.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import XCTest
@testable import Transactions

final class DateExtensionTests: XCTestCase {
    
    func testWithoutTime() {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: 2024, month: 10, day: 15, hour: 14, minute: 30, second: 45)
        guard let originalDate = calendar.date(from: dateComponents) else {
            XCTFail("Failed to create original date")
            return
        }
        
        let dateWithoutTime = originalDate.withoutTime
        
        let expectedDateComponents = DateComponents(year: 2024, month: 10, day: 15, hour: 0, minute: 0, second: 0)
        let expectedDate = calendar.date(from: expectedDateComponents)
        
        XCTAssertEqual(dateWithoutTime, expectedDate, "The date should be the same, but with time set to midnight.")
    }
}
