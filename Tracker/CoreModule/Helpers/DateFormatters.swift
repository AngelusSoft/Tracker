//
//  DateFormatters.swift
//  Tracker
//
//  Created by Michal Miko on 05/10/2020.
//

import Foundation

class Formatters {
    
    static let date: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
       return formatter
    }()
    
    static let duration: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = DateIntervalFormatter.Style.none
        return formatter
    }()
    
    static let interval: DateIntervalFormatter = {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = DateIntervalFormatter.Style.short
        return formatter
    }()
    
    
    
}
