//
//  SportTrackerModel.swift
//  Tracker
//
//  Created by Michal Miko on 04/10/2020.
//

import Foundation
import CoreData

struct Activity: Codable {
    let id: UUID
    let name: String
    let place: String
    let dateOfBegining: Date
    let duration: TimeInterval
    let origin: Origin
}

@objc(ActivityDataMO)
public class ActivityDataMO: NSManagedObject, Identifiable {

    func getActivity() -> Activity {
        return Activity(id: self.id,
                        name: self.name,
                        place: self.place,
                        dateOfBegining: self.date,
                        duration: self.duration,
                        origin: .local)
    }
    
    @nonobjc public class func createfetchRequest() -> NSFetchRequest<ActivityDataMO> {
        return NSFetchRequest<ActivityDataMO>(entityName: "ActivityDataMO")
    }

    @NSManaged public var name: String
    @NSManaged public var place: String
    @NSManaged public var date: Date
    @NSManaged public var duration: Double
    @NSManaged public var id: UUID
}

struct RawActivityData {
    enum ValidationError: Error {
        case name, place, dateOfBegining, duration
    }
    
    var name: String?
    var place: String?
    var dateOfBegining: Date?
    var duration: TimeInterval?
    var destination: Origin
}

struct ActivityData {
    var name: String
    var place: String
    var dateOfBegining: Date
    var duration: TimeInterval
}

enum Origin: String, Codable {
    case remote
    case local
}
