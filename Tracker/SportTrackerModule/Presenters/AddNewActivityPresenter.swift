//
//  AddNewActivityPresenter.swift
//  Tracker
//
//  Created by Michal Miko on 06/10/2020.
//

import Foundation
import UIKit

protocol AddNewActivityPresentable {
    func validationFailed(reason: RawActivityData.ValidationError)
    func saveFailed(error: Error)
    func saveDone()
}

class AddNewActivityPresenter: AddNewActivityPresentable {
    enum StaticStrings {
        static let emptyError = "add_new_activity_validation_error_empty"
        static let saved = "add_new_activity_saved"
    }
    
    private weak var viewController: AddNewActivityDisplayable?
    
    init(_ viewController: AddNewActivityDisplayable) {
        self.viewController = viewController
    }
    
    func validationFailed(reason: RawActivityData.ValidationError) {
        viewController?.validationFailed(toast: StaticStrings.emptyError.localized(), reason: reason)
    }
    
    func saveDone() {
        DispatchQueue.main.async {
            self.viewController?.saveDone(toast: StaticStrings.saved.localized())
        }
    }
    
    func saveFailed(error: Error) {
        DispatchQueue.main.async {
            self.viewController?.saveFailed(toast: error.localizedDescription)
        }
    }
}
