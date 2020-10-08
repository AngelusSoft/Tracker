//
//  ListActivityHeader.swift
//  Tracker
//
//  Created by Michal Miko on 05/10/2020.
//

import Foundation
import UIKit

class ListActivityHeader: UICollectionReusableView {
    
    enum Category {
        case all
        case local
        case remote
    }
    
    static let cellId = "ListActivityHeaderCellId"
    
    var action: ((ListActivityHeader.Category)->())?
    
    enum StaticStrings {
        static let all = "list_filter_all".localized()
        static let local = "list_filter_local".localized()
        static let remote = "list_filter_remote".localized()
    }
    
    
    private let category: [Category] = [.all, .local, .remote]
    let segmentedControl = UISegmentedControl(items: [StaticStrings.all, StaticStrings.local, StaticStrings.remote])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }
    
    func setupLayout() {
        addSubview(segmentedControl)
        translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.createConstraintsToFill(view: self, 10, 5, -10, -15)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(handleSegmentedAction), for: .valueChanged)
    }
    
    @objc func handleSegmentedAction(_ sender: UISegmentedControl) {
        action?(category[sender.selectedSegmentIndex])
        
    }
}
