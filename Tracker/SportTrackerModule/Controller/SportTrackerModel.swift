//
//  SportTrackerModel.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation

struct Activity: Codable {
    let name: String
    let place: Location
    let dateOfBegining: Date
    let duration: TimeInterval
}



struct Location: Codable {
    let longitude: Double
    let latitude: Double
}
