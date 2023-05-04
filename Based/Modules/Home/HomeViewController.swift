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

    private let speechRecognizer = SpeechRecognizer()
    private let audioRecorder = AudioRecorder()
    private weak var dictationTextResult: UITextView?
    private var isRecording: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        setupListenButton()
        setupFilesButton()
        setupDictationButton()
        setupDictationTextView()
        setupTranscribeButton()
        setupRecordButton()
        setupSettingsButton()
    }
    
    private func setupSettingsButton() {
        let gearButton = UIButton()
        let symbolGearConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let gearImage = UIImage(
            systemName: "gearshape.circle.fill",
            withConfiguration: symbolGearConfiguration
        )?.withTintColor(.black)
        gearButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        gearButton.setImage(gearImage, for: .normal)
        gearButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gearButton)
        NSLayoutConstraint.activate([
            gearButton.widthAnchor.constraint(equalToConstant: 50),
            gearButton.heightAnchor.constraint(equalToConstant: 50),
            gearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            gearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }
    
    private func setupRecordButton() {
        let recordButton = UIButton()
        let symbolRecordConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let recordImage = UIImage(
            systemName: "record.circle",
            withConfiguration: symbolRecordConfiguration
        )?.withTintColor(.black)
        recordButton.addTarget(self, action: #selector(handleRecordAudio), for: .touchUpInside)
        recordButton.setImage(recordImage, for: .normal)
        recordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recordButton)
        NSLayoutConstraint.activate([
            recordButton.widthAnchor.constraint(equalToConstant: 50),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupTranscribeButton() {
        let transcribeButton = UIButton()
        let symbolTranscribeConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let transcribeImage = UIImage(
            systemName: "character.textbox",
            withConfiguration: symbolTranscribeConfiguration
        )?.withTintColor(.black)
        transcribeButton.addTarget(self, action: #selector(handleTranscribeAudioToText), for: .touchUpInside)
        transcribeButton.setImage(transcribeImage, for: .normal)
        transcribeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(transcribeButton)
        NSLayoutConstraint.activate([
            transcribeButton.widthAnchor.constraint(equalToConstant: 50),
            transcribeButton.heightAnchor.constraint(equalToConstant: 50),
            transcribeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            transcribeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupListenButton() {
        let listenRecordButton = UIButton()
        let symbolListenConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let listenImage = UIImage(
            systemName: "play.circle.fill",
            withConfiguration: symbolListenConfiguration
        )?.withTintColor(.black)
        listenRecordButton.addTarget(self, action: #selector(handleRecord), for: .touchUpInside)
        listenRecordButton.setImage(listenImage, for: .normal)
        listenRecordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(listenRecordButton)
        NSLayoutConstraint.activate([
            listenRecordButton.widthAnchor.constraint(equalToConstant: 50),
            listenRecordButton.heightAnchor.constraint(equalToConstant: 50),
            listenRecordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            listenRecordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
    }
    
    private func setupFilesButton() {
        let filesButton = UIButton()
        let symbolFilesConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let filesImage = UIImage(
            systemName: "folder.circle.fill",
            withConfiguration: symbolFilesConfiguration
        )?.withTintColor(.black)
        filesButton.setImage(filesImage, for: .normal)
        filesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filesButton)
        NSLayoutConstraint.activate([
            filesButton.widthAnchor.constraint(equalToConstant: 50),
            filesButton.heightAnchor.constraint(equalToConstant: 50),
            filesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            filesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupDictationButton() {
        let dictationButton = UIButton()
        let symbolDictationConfiguration = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold)
        let dictationImage = UIImage(
            systemName: "mic.circle.fill",
            withConfiguration: symbolDictationConfiguration
        )?.withTintColor(.black)
        dictationButton.addTarget(self, action: #selector(handleDictation), for: .touchUpInside)
        dictationButton.setImage(dictationImage, for: .normal)
        dictationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dictationButton)
        NSLayoutConstraint.activate([
            dictationButton.widthAnchor.constraint(equalToConstant: 50),
            dictationButton.heightAnchor.constraint(equalToConstant: 50),
            dictationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dictationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
    }
    
    private func setupDictationTextView() {
        let dictationTextResult = UITextView()
        self.dictationTextResult = dictationTextResult
        dictationTextResult.backgroundColor = .systemGray3
        dictationTextResult.textAlignment = .left
        dictationTextResult.contentMode = .topLeft
        dictationTextResult.layer.cornerRadius = 13
        dictationTextResult.font = .systemFont(ofSize: 24, weight: .regular)
        dictationTextResult.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dictationTextResult)
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
            dictationTextResult.heightAnchor.constraint(equalToConstant: (view.frame.height / 1.5))
        ])
    }
    
    @objc func handleTranscribeAudioToText() {
        endRecording()
        if let url = audioRecorder.getRecordedAudioURL() {
            try? audioRecorder.playRecordedAudio(at: url)
        }
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing(completion: { [weak self] speechResult in
            self?.dictationTextResult?.text = speechResult
        })
        isRecording = true
    }
        
    @objc func handleDictation() {
        if isRecording {
//            endDictation()
            endRecording()
            isRecording = false
        } else {
            speechRecognizer.resetTranscript()
            try? audioRecorder.startRecording()
//            sr.startTranscribing(completion: { [weak self] speechResult in
//                self?.dictationTextResult?.text = speechResult
//            })
            isRecording = true
        }
    }
    
    @objc func handleRecordAudio() {
        
    }
    
    @objc func handleSettings() {
        
    }
    
    @objc func handleRecord() {
        endRecording()
        if let url = audioRecorder.getRecordedAudioURL() {
            try? audioRecorder.playRecordedAudio(at: url)            
        }
    }
    
    func endRecording() {
        audioRecorder.stopRecording()
    }
    
    func endDictation() {
        speechRecognizer.stopTranscribing()
    }
    
}
