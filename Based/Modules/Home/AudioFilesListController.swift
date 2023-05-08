//
//  AudioFilesListController.swift
//  Based
//
//  Created by antuan.khoanh on 08/05/2023.
//

import UIKit
import Foundation
import AVFoundation

class AudioFilesListController: UIViewController {
    fileprivate let AudioViewCellID = "AudioViewCell"
    private weak var recordButton: UIButton!
    private weak var promtView: UIView!
    private var outerBorderLayer: CALayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "All Recordings"
        navigationController?.navigationBar.prefersLargeTitles = true
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AudioViewCell.self, forCellReuseIdentifier: AudioViewCellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController

        let promtView = UIView()
        self.promtView = promtView
        promtView.backgroundColor = .systemGray
        promtView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(promtView)
        
        NSLayoutConstraint.activate([
            promtView.heightAnchor.constraint(equalToConstant: 160),
            promtView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            promtView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            promtView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            promtView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let recordButton = UIButton()
        recordButton.backgroundColor = .red
        self.recordButton = recordButton
        recordButton.addTarget(self, action: #selector(recordButtonTapped), for: .touchUpInside)
        promtView.addSubview(recordButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let view2Width: CGFloat = 70 // Desired width of view2
        let view2Height: CGFloat = 70 // Desired height of view2
        
        let view2X = (promtView.frame.width - view2Width) / 2 // Calculate the x-coordinate for centering view2
        let view2Y = (promtView.frame.height - view2Height) / 2 // Calculate the y-coordinate for centering view2
        
        let view2Frame = CGRect(x: view2X, y: view2Y, width: view2Width, height: view2Height)
        recordButton.frame = view2Frame
        
        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        recordButton.layer.borderWidth = 2.0
        recordButton.layer.borderColor = UIColor.black.cgColor
        
        let outerBorderWidth: CGFloat = 4.0
        let outerBorderColor = UIColor.white.cgColor
        
        if outerBorderLayer == nil {
            outerBorderLayer = CALayer()
            recordButton.layer.addSublayer(outerBorderLayer!)
        }
        
        outerBorderLayer?.frame = CGRect(
            x: -outerBorderWidth,
            y: -outerBorderWidth,
            width: recordButton.frame.width + (2 * outerBorderWidth),
            height: recordButton.frame.height + (2 * outerBorderWidth)
        )
        outerBorderLayer?.borderColor = outerBorderColor
        outerBorderLayer?.borderWidth = outerBorderWidth
        outerBorderLayer?.cornerRadius = (outerBorderLayer?.frame.width ?? 0) / 2
        outerBorderLayer?.masksToBounds = true
    }
    
    @objc func recordButtonTapped() {
//        if isRecording {
//            stopRecording()
//        } else {
//            startRecording()
//        }
    }
    
    func startRecording() {
        recordButton.backgroundColor = .gray
    }

    func stopRecording() {
        recordButton.backgroundColor = .red
    }
    
}

extension AudioFilesListController: UISearchBarDelegate {
    
}

extension AudioFilesListController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioViewCellID, for: indexPath) as! AudioViewCell
        cell.configureCell(title: "Novaya zapis' 1", details: "12 sep 2021", duration: "1:01:00")
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
