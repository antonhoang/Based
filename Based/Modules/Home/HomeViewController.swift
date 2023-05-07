//
//  HomeViewController.swift
//  Based
//
//  Created by antuan.khoanh on 01/05/2023.
//

import UIKit
import Foundation
import AVFoundation

class AudioViewCell: UITableViewCell {
    
    var isExpanded = false {
        didSet {
            updateViewVisibility()
        }
    }
    
    private let additionalView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    let additionalViewHeight: CGFloat = 100
    
    private func updateViewVisibility() {
        additionalView.isHidden = !isExpanded
        additionalView.frame.size.height = isExpanded ? additionalViewHeight : 0
    }
    
    // Declare and configure any necessary UI elements
    let titleLabel: UILabel = {
        let label = UILabel()
        // Configure the label's appearance
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        // Configure the detail label's appearance
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add the subviews to the cell's contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(additionalView)
        
        // Configure the layout and constraints for the subviews
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            additionalView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            additionalView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8),
            additionalView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            additionalView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isExpanded {
            additionalView.isHidden = false
            additionalView.frame = CGRect(
                x: 0,
                y: contentView.frame.size.height,
                width: contentView.frame.size.width,
                height: additionalViewHeight
            )
        } else {
            additionalView.isHidden = true
            additionalView.frame = CGRect(
                x: 0,
                y: contentView.frame.size.height,
                width: contentView.frame.size.width,
                height: 0
            )
        }
    }
}

class AudioFilesListController: UIViewController {
    fileprivate let AudioViewCellID = "AudioViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "All Recordings"
        navigationController?.navigationBar.prefersLargeTitles = true
        let tableView = UITableView(frame: view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AudioViewCell.self, forCellReuseIdentifier: AudioViewCellID)
        view.addSubview(tableView)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        
        // Define whether the search bar is always visible or only visible when scrolling
        definesPresentationContext = false
    }
    var expandedIndexPath: IndexPath?

}

extension AudioFilesListController: UISearchBarDelegate {
    
}

extension AudioFilesListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioViewCellID, for: indexPath) as! AudioViewCell
        cell.titleLabel.text = "Novaya zapis' 1"
        cell.detailLabel.text = "12 sep 2021"
        let durationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 20))
        durationLabel.textColor = .gray
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.textAlignment = .center
        durationLabel.text = "1:01:00"
        cell.accessoryView = durationLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? AudioViewCell else {
            return
        }
        
        if cell.isExpanded {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            deselectExpandedRows(tableView)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        cell.isExpanded.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func deselectExpandedRows(_ tableView: UITableView) {
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            if let cell = tableView.cellForRow(at: indexPath) as? AudioViewCell, cell.isExpanded {
                cell.isExpanded = false
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cell = tableView.cellForRow(at: indexPath) as? AudioViewCell, cell.isExpanded {
            return cell.contentView.frame.size.height + cell.additionalViewHeight
        } else {
            return UITableView.automaticDimension
        }
    }
}

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
        
    @objc func handleSpeechRecognition() {
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing(completion: { [weak self] speechResult in
            self?.dictationTextResult?.text = speechResult
        })
    }
    
    @objc func handleRecordAudio() {
        if isRecording {
            endRecording()
            isRecording = false
        } else {
            try? audioRecorder.startRecording()
            isRecording = true
        }
    }
    
    @objc func handlePlayRecordedAudio() {
        endRecording()
        if let url = audioRecorder.getRecordedAudioURL() {
            try? audioRecorder.playRecordedAudio(at: url)
        }
    }
    
    @objc func handleSettings() {
        
    }
    
    private func endRecording() {
        audioRecorder.stopRecording()
    }
    
    private func endDictation() {
        speechRecognizer.stopTranscribing()
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
        listenRecordButton.addTarget(self, action: #selector(handlePlayRecordedAudio), for: .touchUpInside)
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
        dictationButton.addTarget(self, action: #selector(handleSpeechRecognition), for: .touchUpInside)
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
    
}
