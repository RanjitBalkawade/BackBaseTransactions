//
//  MockHelper.swift
//  TransactionsTests
//
//  Created by Ranjeet Balkawade on 17/10/2024.
//

import Foundation

/// Helper class for mocking data.
class MockHelper {
    
    /// Loads JSON data from a file in bundle with the given filename.
    static func loadJsonData(filename: String) -> Data? {
        let fileURL = Bundle(for: MockHelper.self).url(forResource: filename, withExtension: "json")
        return try? Data(contentsOf: fileURL!)
    }
}
