//
//  BaseNavigationController.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import UIKit

class BaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        navigationBar.prefersLargeTitles = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
