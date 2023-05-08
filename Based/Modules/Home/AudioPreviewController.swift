//
//  AudioPreviewController.swift
//  Based
//
//  Created by antuan.khoanh on 08/05/2023.
//

import Foundation
import UIKit

class AudioPreviewController: UIViewController {
    private weak var progressBar: UIProgressView!
    private weak var durationBeginLabel: UILabel!
    private weak var durationEndLabel: UILabel!
    private weak var playButton: UIButton!
    private weak var openFileButton: UIButton!
    private weak var deleteFileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and configure the progress bar
        let progressBar = UIProgressView(progressViewStyle: .default)
        self.progressBar = progressBar
        progressBar.progressTintColor = .darkGray
        progressBar.trackTintColor = .gray
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressBar)
        
        // Create and configure the duration begin label
        let durationBeginLabel = UILabel()
        self.durationBeginLabel = durationBeginLabel
        durationBeginLabel.textAlignment = .left
        durationBeginLabel.textColor = .gray
        durationBeginLabel.font = UIFont.systemFont(ofSize: 14)
        durationBeginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(durationBeginLabel)
        
        // Create and configure the duration end label
        let durationEndLabel = UILabel()
        self.durationEndLabel = durationEndLabel
        durationEndLabel.textAlignment = .right
        durationEndLabel.textColor = .gray
        durationEndLabel.font = UIFont.systemFont(ofSize: 14)
        durationEndLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(durationEndLabel)
        
        // Create and configure the play button
        let playButton = UIButton()
        self.playButton = playButton
        let symbolPlayButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let playImage = UIImage(
            systemName: "play.fill",
            withConfiguration: symbolPlayButtonConfiguration
        )
        playButton.setImage(playImage, for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)
        
        let openFileButton = UIButton()
        self.openFileButton = openFileButton
        let openFileButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let openFileButtonImage = UIImage(
            systemName: "doc.text",
            withConfiguration: openFileButtonConfiguration
        )
        openFileButton.setImage(openFileButtonImage, for: .normal)
        openFileButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(openFileButton)
        
        let deleteFileButton = UIButton()
        self.deleteFileButton = deleteFileButton
        let deleteFileButtonConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let deleteFileButtonImage = UIImage(
            systemName: "trash",
            withConfiguration: deleteFileButtonConfiguration
        )
        deleteFileButton.setImage(deleteFileButtonImage, for: .normal)
        deleteFileButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(deleteFileButton)
        
        // Define layout constraints for the views
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            durationBeginLabel.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            durationBeginLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            
            durationEndLabel.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor),
            durationEndLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 8),
            
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.topAnchor.constraint(equalTo: durationBeginLabel.bottomAnchor, constant: 8),
            
            openFileButton.topAnchor.constraint(equalTo: playButton.topAnchor),
            openFileButton.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor),
            
            deleteFileButton.topAnchor.constraint(equalTo: playButton.topAnchor),
            deleteFileButton.trailingAnchor.constraint(equalTo: progressBar.trailingAnchor)
        ])
        
        // Set initial values
        progressBar.progress = 0.5 // Set the progress to half (0.0 - 1.0)
        durationBeginLabel.text = "0:00" // Set the initial begin duration
        durationEndLabel.text = "-3:42" // Set the initial end duration
        
        // Add target action for the play button
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    @objc func playButtonTapped() {
        // Handle play button tap event
        // Implement your play/pause functionality here
    }
}
