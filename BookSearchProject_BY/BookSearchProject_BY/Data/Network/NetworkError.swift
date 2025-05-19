//
//  NetworkError.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/16/25.
//

import Foundation

/// 네트워크 작업 수행 중 발생할 수 있는 에러 정의
enum NetworkError: Error {
    case invalidUrl
    case dataFetchFail
    case decodingFail
}

// MARK: - LocalizedError
extension NetworkError: LocalizedError {
    /// 사용자에게 표시할 에러 메시지
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "잘못된 URL 형식입니다."
        case .dataFetchFail:
            return "데이터를 가져오는데 실패했습니다."
        case .decodingFail:
            return "데이터 변환에 실패했습니다."
        }
    }
}
