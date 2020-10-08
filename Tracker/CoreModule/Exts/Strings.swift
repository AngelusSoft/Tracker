//
//  Strings.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
