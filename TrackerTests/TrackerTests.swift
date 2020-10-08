//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Michal Miko on 04/10/2020.
//

import XCTest
@testable import Tracker

class TrackerTests: XCTestCase {
    func testListPresenter() throws {
        let listSpy = ListActivitySPY()
        let presenter = ListActivityPresenter(listSpy)
        
        guard let date = DateComponents(calendar: .current, timeZone: .current, year: 2020, month: 10, day: 03, hour: 10).date else { XCTFail(); return }
        
        let activity = Activity(id: UUID(), name: "Test Activity", place: "Test Place", dateOfBegining: date, duration: 300, origin: .remote)
        presenter.presentActivityList([activity, activity, activity])
        
        XCTAssert(listSpy.model.count == 3)
        guard let model = listSpy.model.first else { XCTFail(); return }
        XCTAssert(model.duration == "10/3/20, 10:00 – 10:05 AM" )
        XCTAssert(model.location == activity.place)
        XCTAssert(model.type == activity.name)
    }
}
