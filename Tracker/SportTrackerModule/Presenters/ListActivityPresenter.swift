//
//  AddNewActivityPresenter.swift
//  Tracker
//
//  Created by Michal Miko on 06/10/2020.
//

import Foundation
import UIKit

protocol ListActivityPresentable {
    func presentActivityList(_ list: [Activity])
    func localFetchFailure(error: Error)
}

class ListActivityPresenter: ListActivityPresentable {
    enum StaticStrings {
        static let emptyError = "add_new_activity_validation_error_empty"
        static let saved = "add_new_activity_saved"
    }
    
    private weak var viewController: ListActivityDisplayable?
    
    init(_ viewController: ListActivityDisplayable) {
        self.viewController = viewController
    }
    
    func presentActivityList(_ list: [Activity]) {
        let viewModel: [ActivityViewModel] = list.map({ activity in
            
            let interval = Formatters.interval.string(from: activity.dateOfBegining,
                                                      to: activity.dateOfBegining.addingTimeInterval(activity.duration))
            return ActivityViewModel(type: activity.name,
                                     duration: interval,
                                     location: activity.place,
                                     origin: activity.origin)
        })
        
        viewController?.presentActivity(model: viewModel)
    }
    
    func localFetchFailure(error: Error) {
        viewController?.showError(text: error.localizedDescription)
    }
}
