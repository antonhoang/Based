//
//  AudioViewCell.swift
//  Based
//
//  Created by antuan.khoanh on 08/05/2023.
//

import Foundation
import UIKit

class AudioViewCell: UITableViewCell {
    
    var isExpanded = false {
        didSet {
            updateViewVisibility()
        }
    }
    
    private let additionalView: UIView = {
        let preview = AudioPreviewController()
        return preview.view
    }()
    
    let additionalViewHeight: CGFloat = 100
    
    private func updateViewVisibility() {
        additionalView.isHidden = !isExpanded
        additionalView.frame.size.height = isExpanded ? additionalViewHeight : 0
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .black
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add the subviews to the cell's contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(additionalView)
        
        // Configure the layout and constraints for the subviews
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            durationLabel.bottomAnchor.constraint(equalTo: detailLabel.bottomAnchor),
            
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
    
    func configureCell(
        title: String,
        details: String,
        duration: String
    ) {
        titleLabel.text = title
        detailLabel.text = details
        durationLabel.text = duration
    }
}
