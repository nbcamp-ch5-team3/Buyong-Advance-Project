//
//  Int+.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

import Foundation

/// 정수를 천 단위로 쉼표(,)가 포함된 문자열로 변환하여 반환
extension Int {
    var decimalFormatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
