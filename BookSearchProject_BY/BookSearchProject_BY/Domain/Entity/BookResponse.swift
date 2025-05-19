//
//  SearchViewModel.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

/// 카카오 책 검색 API 응답 모델 (검색 결과 메타데이터, 검색 된 책 목록)
struct BookResponse: Decodable {
    let meta: Meta
    let documents: [Book]
}

/// 검색 결과 메타데이터 모델
struct Meta: Decodable {
    let isEnd: Bool
    let totalCount: Int
    let pageableCount: Int
    
    /// JSON 키와 프로퍼티 매핑을 위한 CodingKeys
    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
    }
}
