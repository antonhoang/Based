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
