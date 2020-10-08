//
//  ListOfActivityViewModel.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation

enum Section {
    case main
}

struct ActivityViewModel: Hashable {
    
    let id = UUID()
    let type: String
    let duration: String
    let location: String
    let origin: Origin
    
    static var debug = [
        ActivityViewModel(type: "Tenis", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Fotbal", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Tenis", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Fotbal", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .remote),
        ActivityViewModel(type: "Tenis", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Fotbal", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .remote),
        ActivityViewModel(type: "Tenis", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Fotbal", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Tenis", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Fotbal", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Tenis", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Fotbal", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Nohejbal", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
        ActivityViewModel(type: "Zadek", duration: "1.1.2010 - 10:30 - 12:30", location: "Tady", origin: .local),
    ]
}
