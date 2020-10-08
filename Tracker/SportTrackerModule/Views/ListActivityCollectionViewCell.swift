//
//  ListActivityCollectionViewCell.swift
//  Tracker
//
//  Created by Michal Miko on 05/10/2020.
//

import Foundation
import UIKit

class ListActivityCollectionViewCell: UICollectionViewCell {
    static let cellId = "LACellID"
    
    private let lblTitle: UILabel = {
        let label = UILabel()
        label.font = AppTheme.Fonts.cellTitle
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    private let lblTime: UILabel = {
        let label = UILabel()
        label.font = AppTheme.Fonts.cellSubtitle
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let lblLocation: UILabel = {
        let label = UILabel()
        label.font = AppTheme.Fonts.cellLocation
        label.minimumScaleFactor = 0.3
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let lblStorage: UILabel = {
        let label = UILabel()
        label.text = "Storage"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private let cardView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupLayout() {
        contentView.addSubview(cardView)
        cardView.createConstraintsToFill(view: contentView, 10, 10, -10, -10)
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        let imageViewWrapper = UIView()
        imageViewWrapper.translatesAutoresizingMaskIntoConstraints = false
        [lblTitle, lblTime, lblLocation].forEach { [weak self] (view) in
            self?.cardView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        cardView.addSubview(imageViewWrapper)
        
        imageViewWrapper.topAnchor.constraint(equalTo: cardView.topAnchor).isActive = true
        imageViewWrapper.trailingAnchor.constraint(equalTo: cardView.trailingAnchor).isActive = true
        imageViewWrapper.bottomAnchor.constraint(equalTo: cardView.bottomAnchor).isActive = true
        imageViewWrapper.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.25).isActive = true
        
        imageViewWrapper.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageViewWrapper.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageViewWrapper.centerYAnchor).isActive = true
        
        imageViewWrapper.addSubview(lblStorage)
        lblStorage.translatesAutoresizingMaskIntoConstraints = false
        lblStorage.centerXAnchor.constraint(equalTo: imageViewWrapper.centerXAnchor).isActive = true
        lblStorage.bottomAnchor.constraint(equalTo: imageViewWrapper.centerYAnchor, constant: -15).isActive = true
        
        lblTitle.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10).isActive = true
        lblTitle.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10).isActive = true
        lblTitle.trailingAnchor.constraint(equalTo: imageViewWrapper.leadingAnchor, constant: -10).isActive = true
        
        lblTime.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: 0).isActive = true
        lblTime.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        lblTime.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor).isActive = true
        
        lblLocation.topAnchor.constraint(equalTo: lblTime.bottomAnchor, constant: 0).isActive = true
        lblLocation.leadingAnchor.constraint(equalTo: lblTitle.leadingAnchor).isActive = true
        lblLocation.trailingAnchor.constraint(equalTo: lblTitle.trailingAnchor).isActive = true
        lblLocation.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10).isActive = true
        
    }
    
    func configure(with model: ActivityViewModel) {
        lblTitle.text = model.type
        lblTime.text = model.duration
        lblLocation.text = model.location
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = AppTheme.Colors.toolbarBackground.cgColor
        imageView.superview?.backgroundColor = AppTheme.Colors.toolbarBackground
        let configuration = UIImage.SymbolConfiguration(pointSize: 22, weight: .semibold)
        switch model.origin {
        case .local:
            imageView.image = UIImage.init(systemName: "folder.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .systemRed
        case .remote:
            imageView.image = UIImage.init(systemName: "icloud.fill", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .systemBlue
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        
        layoutAttributes.frame = frame
        
        return layoutAttributes
    }
}
