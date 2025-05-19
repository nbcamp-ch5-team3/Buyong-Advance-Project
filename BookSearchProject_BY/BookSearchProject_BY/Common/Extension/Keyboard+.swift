//
//  Keyboard+.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/15/25.
//

import UIKit

extension UIViewController {
    /// 키보드 옵저버 추가
    func addKeyboardObserver() {
        // 화면 터치시 키보드 내리기 위한 제스처 추가
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    /// 옵저버 제거
    func removeKeyboardObserver() {
        view.gestureRecognizers?.removeAll()
    }
    
    /// 화면 터치시 키보드 내리기
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
