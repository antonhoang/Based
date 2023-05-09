//
//  AudioViewCell.swift
//  Based
//
//  Created by antuan.khoanh on 08/05/2023.
//

import Foundation
import UIKit

class AudioViewCell: UITableViewCell {
    
    typealias Action = () -> Void
    public var shareFileAction: Action?
    public let additionalPreview: AudioPreviewController = {
        let preview = AudioPreviewController()
        return preview
    }()
    
    let additionalPreviewHeight: CGFloat = 100
    
    var isExpanded = false {
        didSet {
            updateViewVisibility()
        }
    }
    
    private func updateViewVisibility() {
        additionalPreview.view.isHidden = !isExpanded
        additionalPreview.view.frame.size.height = isExpanded ? additionalPreviewHeight : 0
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
    
    private let shareButton: UIButton = {
        let share = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 24)
        let image = UIImage(
            systemName: "square.and.arrow.up",
            withConfiguration: config
        )
        share.setImage(image, for: .normal)
        share.tintColor = .lightGray
        return share
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add the subviews to the cell's contentView
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(additionalPreview.view)
        contentView.addSubview(shareButton)
        
        
        // Configure the layout and constraints for the subviews
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        additionalPreview.view.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                        
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            durationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            durationLabel.bottomAnchor.constraint(equalTo: detailLabel.bottomAnchor),
            
            additionalPreview.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            additionalPreview.view.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 8),
            additionalPreview.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            additionalPreview.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            shareButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            shareButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        setupActions()
    }
    
    private func setupActions() {
        shareButton.addTarget(self, action: #selector(handleShare), for: .touchUpInside)
    }
    
    @objc func handleShare() {
        shareFileAction?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isExpanded {
            additionalPreview.view.isHidden = false
            shareButton.isHidden = false
            durationLabel.isHidden = true
            additionalPreview.view.frame = CGRect(
                x: 0,
                y: contentView.frame.size.height,
                width: contentView.frame.size.width,
                height: additionalPreviewHeight
            )
        } else {
            additionalPreview.view.isHidden = true
            shareButton.isHidden = true
            durationLabel.isHidden = false
            additionalPreview.view.frame = CGRect(
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
