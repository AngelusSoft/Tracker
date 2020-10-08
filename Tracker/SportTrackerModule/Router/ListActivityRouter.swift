//
//  ListActivityRouter.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import UIKit

class ListActivityRouter {
    
    enum Destination {
        case addNewActivity
    }
    
    private weak var controller: ListOfActivityViewController?
    
    init(_ controller: ListOfActivityViewController) {
        self.controller = controller
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .addNewActivity:
            let addNewVC = AddNewActivityViewController()
           // let addNewNC = BaseNavigationController(rootViewController: addNewVC)
            addNewVC.delegate = controller
           controller?.present(addNewVC, animated: true, completion: nil)
        }
    }
}
