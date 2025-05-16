//
//  NetworkManager.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/12/25.
//

import Foundation
import Alamofire
import RxSwift

// 네트워크 통신을 담당: 싱글톤 인스턴스
final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    /// Generic 타입의 데이터를 서버로부터 가져오는 메서드
    /// - Parameters:
    ///   - url: API 요청 URL 문자열
    ///   - headers: HTTP 요청 헤더 (선택사항)
    /// - Returns: 디코딩된 데이터를 포함하는 Single 옵저버블
    /// - Note: RxSwift의 Single을 사용하여 성공 또는 실패를 한 번만 방출
    func fetch<T: Decodable>(url: String, headers: HTTPHeaders? = nil) -> Single<T> {
        return Single.create { observer in
            AF.request(url, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let value):
                        observer(.success(value))
                    case .failure(let error):
                        observer(.failure(error))
                    }
                }
            return Disposables.create()
        }
    }
}
