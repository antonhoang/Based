//
//  HomeViewController.swift
//  Based
//
//  Created by antuan.khoanh on 01/05/2023.
//

import UIKit
import Foundation
import AVFoundation

class HomeViewController: UIViewController {

    let sr = SpeechRecognizer()
    let ar = AudioRecorder()
    
    let dictationButton = UIButton()
    let filesButton = UIButton()
    let listenRecordButton = UIButton()
    let dictationTextResult = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        
        let symbolListenConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let listenImage = UIImage(
            systemName: "play.circle.fill",
            withConfiguration: symbolListenConfiguration
        )?.withTintColor(.black)
        listenRecordButton.setImage(listenImage, for: .normal)
//        ar.audioRecorder?.delegate = self
//        ar.audioPlayer?.delegate = self
        
//        let symbolFilesConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
//        let filesImage = UIImage(
//            systemName: "folder.circle.fill",
//            withConfiguration: symbolFilesConfiguration
//        )?.withTintColor(.black)
//        filesButton.setImage(filesImage, for: .normal)
        
        let symbolDictationConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let dictationImage = UIImage(
            systemName: "mic.circle.fill",
            withConfiguration: symbolDictationConfiguration
        )?.withTintColor(.black)
        dictationButton.setImage(dictationImage, for: .normal)

        dictationTextResult.backgroundColor = .systemGray3
        dictationTextResult.textAlignment = .left
        dictationTextResult.contentMode = .topLeft
        dictationTextResult.layer.cornerRadius = 13
        dictationTextResult.font = .systemFont(ofSize: 24, weight: .regular)
        
        view.addSubview(dictationButton)
        view.addSubview(dictationTextResult)
        view.addSubview(listenRecordButton)
        dictationButton.translatesAutoresizingMaskIntoConstraints = false
        dictationTextResult.translatesAutoresizingMaskIntoConstraints = false
        listenRecordButton.translatesAutoresizingMaskIntoConstraints = false
        
        var notchHeightConstantSpace: CGFloat = 16
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let windowScene {
            if let topPadding = windowScene.windows.first?.safeAreaInsets.top {
                let notchHeight = topPadding > 0 ? topPadding - 20 : 0
                notchHeightConstantSpace += notchHeight
            }
        }
        
        NSLayoutConstraint.activate([
            dictationTextResult.topAnchor.constraint(equalTo: view.topAnchor, constant: notchHeightConstantSpace),
            dictationTextResult.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            dictationTextResult.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            dictationTextResult.heightAnchor.constraint(equalToConstant: (view.frame.height / 1.5)),
            dictationButton.widthAnchor.constraint(equalToConstant: 50),
            dictationButton.heightAnchor.constraint(equalToConstant: 50),
            dictationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dictationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            listenRecordButton.widthAnchor.constraint(equalToConstant: 50),
            listenRecordButton.heightAnchor.constraint(equalToConstant: 50),
            listenRecordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            listenRecordButton.trailingAnchor.constraint(equalTo: dictationButton.leadingAnchor, constant: -24)
        ])
        dictationButton.addTarget(self, action: #selector(handleDictation), for: .touchUpInside)
        listenRecordButton.addTarget(self, action: #selector(handleRecord), for: .touchUpInside)
    }
    
    var isRecording: Bool = false
    
    @objc func handleDictation() {
        if isRecording {
            endDictation()
            endRecording()
            isRecording = false
        } else {
            sr.resetTranscript()
            try? ar.startRecording()
            sr.startTranscribing(completion: { [weak self] speechResult in
                self?.dictationTextResult.text = speechResult
            })
            isRecording = true
        }
    }
    
    @objc func handleRecord() {
        endRecording()
        if let url = ar.getRecordedAudioURL() {
            try? ar.playRecordedAudio(at: url)            
        }
    }
    
    func endRecording() {
        ar.stopRecording()
    }
    
    func endDictation() {
        sr.stopTranscribing()
    }
    
}
