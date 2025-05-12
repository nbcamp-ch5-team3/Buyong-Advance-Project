//
//  Int+.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

import Foundation

extension Int {
    var decimalFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
