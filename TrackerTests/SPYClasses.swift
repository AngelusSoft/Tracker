//
//  SPYClasses.swift
//  TrackerTests
//
//  Created by Michal Miko on 07/10/2020.
//

import Foundation
@testable import Tracker


class ListActivitySPY: ListActivityDisplayable {
    var model: [ActivityViewModel] = []
    func showError(text: String) {
        
    }
    
    func presentActivity(model: [ActivityViewModel]) {
        self.model = model
    }
}
