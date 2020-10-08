//
//  Theme.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import UIKit

enum AppTheme {
    enum Fonts {
        static let cellTitle: UIFont = UIFont.preferredFont(forTextStyle: .headline)
        static let cellSubtitle: UIFont = UIFont.preferredFont(forTextStyle: .footnote)
        static let cellLocation: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
        
        static let detailTitle: UIFont = UIFont.preferredFont(forTextStyle: .headline)
        static let labelTitle: UIFont = UIFont.preferredFont(forTextStyle: .caption2)
        static let textfield: UIFont = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    enum Colors {
        static let toolbarBackground: UIColor = UIColor.systemGray6
        static let toolbarButtonBackground: UIColor = .gray
        static let toolbarButtonText: UIColor = UIColor.white
        static let labelTitle: UIColor = UIColor.secondaryLabel
        
    }
    
    static let bottomViewButtonSize: CGSize = CGSize(width: 50, height: 50)
    static let bottomViewButtonImageName = "plus"
    
    
}
