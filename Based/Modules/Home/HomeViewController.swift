//
//  HomeViewController.swift
//  Based
//
//  Created by antuan.khoanh on 01/05/2023.
//

import UIKit

class HomeViewController: UIViewController {

    let sr = SpeechRecognizer()
    
    let dictationButton = UIButton()
    let dictationTextResult = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let image = UIImage(
            systemName: "mic.square.fill",
            withConfiguration: symbolConfiguration
        )?.withTintColor(.black)
        dictationButton.setImage(image, for: .normal)

        dictationTextResult.backgroundColor = .systemGray3
        dictationTextResult.textAlignment = .left
        dictationTextResult.contentMode = .topLeft
        dictationTextResult.layer.cornerRadius = 13
        dictationTextResult.font = .systemFont(ofSize: 24, weight: .regular)
        
        view.addSubview(dictationButton)
        view.addSubview(dictationTextResult)
        dictationButton.translatesAutoresizingMaskIntoConstraints = false
        dictationTextResult.translatesAutoresizingMaskIntoConstraints = false
        
        var notchHeightConstantSpace: CGFloat = 12
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let topPadding = windowScene.windows.first?.safeAreaInsets.top {
            let notchHeight = topPadding > 0 ? topPadding - 20 : 0
            notchHeightConstantSpace += notchHeight
        }
        
        NSLayoutConstraint.activate([
            dictationTextResult.topAnchor.constraint(equalTo: view.topAnchor, constant: notchHeightConstantSpace),
            dictationTextResult.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dictationTextResult.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dictationTextResult.heightAnchor.constraint(equalToConstant: (view.frame.height / 1.5)),
            dictationButton.widthAnchor.constraint(equalToConstant: 50),
            dictationButton.heightAnchor.constraint(equalToConstant: 50),
            dictationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dictationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        dictationButton.addTarget(self, action: #selector(handleDictation), for: .touchUpInside)
    }
    
    @objc func handleDictation() {
        sr.resetTranscript()
        sr.startTranscribing(completion: { [weak self] speechResult in
            self?.dictationTextResult.text = speechResult
        })
    }
    
    func endDictation() {
        sr.stopTranscribing()
    }
    
}
