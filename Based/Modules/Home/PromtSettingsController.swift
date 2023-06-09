//
//  PromtSettings.swift
//  Based
//
//  Created by antuan.khoanh on 08/05/2023.
//

import Foundation
import UIKit


class PromtSettingsController: UIViewController {
    
    private weak var topToolbarContainerView: UIView!
    private weak var firstSectionView: UIView!
    private weak var playbackSpeedLabel: UILabel!
    private weak var secondSectionView: UIView!
    private weak var slider: UISlider!
    private weak var skipSilenceToggle: UISwitch!
    private weak var enhanceRecordToggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        setupTopToolbar()
        setupPlaybackSpeedLabel()
        setupFirstSectionView()
        setupSecondSectionView()
    }
    
    @objc func handleReset() {
        slider.value = 0
        skipSilenceToggle.isOn = false
        enhanceRecordToggle.isOn = false
    }
    
    @objc func handleClose() {
        dismiss(animated: true)
    }
    @objc func handleSkipSilence() {
        
    }
    @objc func handleEnhanceRecord() {
        
    }
    @objc func handleSlider() {
        
    }
    
    private func setupPlaybackSpeedLabel() {
        let playbackSpeedLabel = UILabel()
        self.playbackSpeedLabel = playbackSpeedLabel
        playbackSpeedLabel.text = "Playback Speed"
        playbackSpeedLabel.font = UIFont.boldSystemFont(ofSize: 18)
        playbackSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playbackSpeedLabel)
        NSLayoutConstraint.activate([
            playbackSpeedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            playbackSpeedLabel.topAnchor.constraint(equalTo: topToolbarContainerView.bottomAnchor, constant: 16),
        ])
    }
    
    private func setupFirstSectionView() {
        let firstSectionView = UIView()
        firstSectionView.backgroundColor = .systemGray4
        self.firstSectionView = firstSectionView
        firstSectionView.layer.cornerRadius = 13
        firstSectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstSectionView)
        
        
        let tortoise = UIImage(
            systemName: "tortoise",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)
        )
        let tortoiseView = UIImageView(image: tortoise)
        tortoiseView.tintColor = .lightGray
        tortoiseView.translatesAutoresizingMaskIntoConstraints = false
        firstSectionView.addSubview(tortoiseView)
        
        let hare = UIImage(
            systemName: "hare",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)
        )
        let hareView = UIImageView(image: hare)
        hareView.tintColor = .lightGray
        hareView.translatesAutoresizingMaskIntoConstraints = false
        firstSectionView.addSubview(hareView)
        
        let slider = UISlider()
        self.slider = slider
        slider.minimumValue = 0
        slider.maximumValue = 7
        slider.tintColor = .systemGray
        slider.translatesAutoresizingMaskIntoConstraints = false
        firstSectionView.addSubview(slider)
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        firstSectionView.addSubview(lineView)
        
        let skipSilenceLabel = UILabel()
        skipSilenceLabel.text = "Skip Silence"
        skipSilenceLabel.textColor = .white
        skipSilenceLabel.font = UIFont.systemFont(ofSize: 18)
        skipSilenceLabel.translatesAutoresizingMaskIntoConstraints = false
        firstSectionView.addSubview(skipSilenceLabel)
        
        let toggleSwitch = UISwitch()
        self.skipSilenceToggle = toggleSwitch
        toggleSwitch.isOn = false
        toggleSwitch.addTarget(self, action: #selector(handleSkipSilence), for: .touchUpInside)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        firstSectionView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            firstSectionView.topAnchor.constraint(equalTo: playbackSpeedLabel.bottomAnchor, constant: 8),
            firstSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            firstSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            firstSectionView.heightAnchor.constraint(equalToConstant: 104),

            tortoiseView.topAnchor.constraint(equalTo: firstSectionView.topAnchor, constant: 12),
            tortoiseView.leadingAnchor.constraint(equalTo: firstSectionView.leadingAnchor, constant: 16),
            
            slider.topAnchor.constraint(equalTo: firstSectionView.topAnchor, constant: 16),
            slider.centerXAnchor.constraint(equalTo: firstSectionView.centerXAnchor),
            slider.leadingAnchor.constraint(equalTo: tortoiseView.trailingAnchor, constant: 16),

            hareView.topAnchor.constraint(equalTo: tortoiseView.topAnchor),
            hareView.trailingAnchor.constraint(equalTo: firstSectionView.trailingAnchor, constant: -16),
            hareView.leadingAnchor.constraint(equalTo: slider.trailingAnchor, constant: 16),
            
            lineView.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 16),
            lineView.leadingAnchor.constraint(equalTo: firstSectionView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: firstSectionView.trailingAnchor),
            lineView.centerYAnchor.constraint(equalTo: firstSectionView.centerYAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
            
            skipSilenceLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 12),
            skipSilenceLabel.leadingAnchor.constraint(equalTo: tortoiseView.leadingAnchor),
            
            toggleSwitch.topAnchor.constraint(equalTo: skipSilenceLabel.topAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: hareView.trailingAnchor)
        ])
    }
    
    private func setupSecondSectionView() {
        let secondSectionView = UIView()
        self.secondSectionView = secondSectionView
        secondSectionView.backgroundColor = .systemGray4
        secondSectionView.layer.cornerRadius = 13
        secondSectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondSectionView)
        
        let enhanceRecordingLabel = UILabel()
        enhanceRecordingLabel.text = "Enhance Recording"
        enhanceRecordingLabel.textColor = .white
        enhanceRecordingLabel.font = UIFont.systemFont(ofSize: 18)
        enhanceRecordingLabel.translatesAutoresizingMaskIntoConstraints = false
        secondSectionView.addSubview(enhanceRecordingLabel)
        
        let toggleSwitch = UISwitch()
        self.enhanceRecordToggle = toggleSwitch
        toggleSwitch.isOn = false
        toggleSwitch.addTarget(self, action: #selector(handleEnhanceRecord), for: .touchUpInside)
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        secondSectionView.addSubview(toggleSwitch)
        
        NSLayoutConstraint.activate([
            secondSectionView.topAnchor.constraint(equalTo: firstSectionView.bottomAnchor, constant: 16),
            secondSectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            secondSectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            secondSectionView.heightAnchor.constraint(equalToConstant: 52),
            
            enhanceRecordingLabel.centerYAnchor.constraint(equalTo: secondSectionView.centerYAnchor),
            enhanceRecordingLabel.leadingAnchor.constraint(equalTo: secondSectionView.leadingAnchor, constant: 16),
            
            toggleSwitch.centerYAnchor.constraint(equalTo: enhanceRecordingLabel.centerYAnchor),
            toggleSwitch.trailingAnchor.constraint(equalTo: secondSectionView.trailingAnchor, constant: -16)
        ])
        
    }
    
    private func setupTopToolbar() {
        let topToolbarContainerView = UIView()
        self.topToolbarContainerView = topToolbarContainerView
        topToolbarContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topToolbarContainerView)
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.darkGray, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        resetButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        topToolbarContainerView.addSubview(resetButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "Options"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topToolbarContainerView.addSubview(titleLabel)
        
        let xButton = UIButton(type: .system)
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        xButton.tintColor = .black
        xButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        xButton.translatesAutoresizingMaskIntoConstraints = false
        topToolbarContainerView.addSubview(xButton)
        
        NSLayoutConstraint.activate([
            topToolbarContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            topToolbarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topToolbarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topToolbarContainerView.heightAnchor.constraint(equalToConstant: 40),

            resetButton.leadingAnchor.constraint(equalTo: topToolbarContainerView.leadingAnchor, constant: 16),
            resetButton.topAnchor.constraint(equalTo: topToolbarContainerView.topAnchor, constant: 10),
            
            titleLabel.centerXAnchor.constraint(equalTo: topToolbarContainerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topToolbarContainerView.topAnchor, constant: 16),
            
            xButton.trailingAnchor.constraint(equalTo: topToolbarContainerView.trailingAnchor, constant: -16),
            xButton.topAnchor.constraint(equalTo: topToolbarContainerView.topAnchor, constant: 16)
        ])
    }
    
}

