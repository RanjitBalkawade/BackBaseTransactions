//
//  MockHelper.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation

class MockHelper {
    static func loadJsonData(filename: String) -> Data? {
        let fileURL = Bundle(for: MockHelper.self).url(forResource: filename, withExtension: "json")
        return try? Data(contentsOf: fileURL!)
    }
}
