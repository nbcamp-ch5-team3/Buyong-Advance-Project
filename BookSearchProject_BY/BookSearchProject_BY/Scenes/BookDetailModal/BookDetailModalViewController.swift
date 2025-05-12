//
//  BookDetailViewController.swift
//  BookSearchProject_BY
//
//  Created by iOS study on 5/9/25.
//

import UIKit

class BookDetailModalViewController: UIViewController {
    private let detailView = BookDetailModalView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModalPresentation()
        setupView()
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
    
    private func setupActions() {
        detailView.closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        //detailView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}
