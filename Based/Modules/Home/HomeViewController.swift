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
    let dictationTextResult = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dictationButton.backgroundColor = .cyan
        dictationTextResult.backgroundColor = .brown
        
        view.addSubview(dictationButton)
        view.addSubview(dictationTextResult)
        dictationButton.translatesAutoresizingMaskIntoConstraints = false
        dictationTextResult.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dictationButton.widthAnchor.constraint(equalToConstant: 50),
            dictationButton.heightAnchor.constraint(equalToConstant: 50),
            dictationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dictationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dictationTextResult.topAnchor.constraint(equalTo: dictationButton.bottomAnchor),
            dictationTextResult.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dictationTextResult.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dictationTextResult.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        dictationButton.addTarget(self, action: #selector(handleDictation), for: .touchUpInside)

    }
    
    @objc func handleDictation() {
        sr.startTranscribing()
        dictationTextResult.text =  sr.transcript 
    }
    
}
