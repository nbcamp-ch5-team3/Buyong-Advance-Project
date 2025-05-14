//
//  BookDetailViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

protocol BookDetailModalDelegate: AnyObject {
    func didSaveBook(title: String, author: String, price: Int64, isSaved: Bool)
    func modalDidDismiss()
}

final class BookDetailModalViewController: UIViewController {
    weak var delegate: BookDetailModalDelegate?

    private let detailView = BookDetailModalView()
    
    private var book: Book?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.modalDidDismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalPresentation()
        setupView()
        setupActions()
        
        // viewDidLoad 시점에 book이 있으면 detailView에 데이터 세팅
        if let book = book {
            detailView.configure(with: book)
        }
    }
    
    private func configureModalPresentation() {
        self.modalPresentationStyle = .pageSheet
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [
                .custom(identifier: .init("custom")) { _ in
                    return UIScreen.main.bounds.height * 0.8
                }
            ]
            
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
    }
    
    private func setupView() {
        view = detailView
    }
    
    // 외부에서 데이터를 세팅할 수 있도록 설정
    func configure(with book: Book) {
        self.book = book
        detailView.configure(with: book)
    }
    
    private func setupActions() {
        detailView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped() {
        guard let book = book else { return }
        
        // 저장 결과 받아오기
        let isSaved = CoreDataManager.shared.saveBook(
            title: book.title,
            author: book.authors.first ?? "",
            price: Int64(book.price)
        )
        
        // 저장 결과를 delegate로 전달
        delegate?.didSaveBook(
            title: book.title,
            author: book.authors.first ?? "",
            price: Int64(book.price),
            isSaved: isSaved
        )
        dismiss(animated: true)
    }
}
