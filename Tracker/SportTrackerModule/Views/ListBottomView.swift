//
//  View.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import UIKit

class BottomView: UIView {

    private let centralButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: AppTheme.bottomViewButtonImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.tintColor = AppTheme.Colors.toolbarButtonText
        button.layer.cornerRadius = AppTheme.bottomViewButtonSize.height / 2
        button.backgroundColor = AppTheme.Colors.toolbarButtonBackground
        return button
    }()
    let action: ()->()
    
    init(buttonAction: @escaping ()->()) {
        self.action = buttonAction
        super.init(frame: .zero)
        setupLayout()
    }
    
    func setupLayout() {
        backgroundColor = .clear
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        addSubview(centralButton)
        view.backgroundColor = AppTheme.Colors.toolbarBackground
        centralButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        centralButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        centralButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        centralButton.heightAnchor.constraint(equalToConstant: AppTheme.bottomViewButtonSize.height).isActive = true
        centralButton.widthAnchor.constraint(equalToConstant: AppTheme.bottomViewButtonSize.width).isActive = true
        
        view.topAnchor.constraint(equalTo: centralButton.centerYAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    @objc func handleButton() {
        action()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
