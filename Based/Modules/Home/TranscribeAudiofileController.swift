//
//  TranscribeAudiofileController.swift
//  Based
//
//  Created by antuan.khoanh on 08/05/2023.
//

import Foundation
import UIKit

class TranscribeAudioFileController: UIViewController {
    
    private weak var textResult: UITextView!
    private let previewConstant: CGFloat = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelfUI()
        setupTextView()
        setupPreview()
    }
    
    private func setupSelfUI() {
        view.backgroundColor = .white
    }
    
    private func setupPreview() {
        let preview = AudioPreviewController()
        preview.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(preview.view)
        NSLayoutConstraint.activate([
            preview.view.topAnchor.constraint(equalTo: textResult.bottomAnchor, constant: 24),
            preview.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            preview.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            preview.view.heightAnchor.constraint(equalToConstant: previewConstant)
        ])
    }
    
    private func setupTextView() {
        let textResult = UITextView()
        self.textResult = textResult
        textResult.backgroundColor = .systemGray3
        textResult.textAlignment = .left
        textResult.contentMode = .topLeft
        textResult.layer.cornerRadius = 13
        textResult.font = .systemFont(ofSize: 24, weight: .regular)
        textResult.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textResult)

        NSLayoutConstraint.activate([
            textResult.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textResult.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            textResult.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            textResult.heightAnchor.constraint(equalToConstant: view.frame.height - (previewConstant * 2))
        ])
    }
    
}
