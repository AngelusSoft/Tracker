//
//  TrackerUITests.swift
//  TrackerUITests
//
//  Created by Michal Miko on 04/10/2020.
//

import XCTest

class TrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAddLocalAktivity() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.buttons.firstMatch.tap()
        waitForLabel("title_label")
        let name = "Test Activity \(Int.random(in: 0...10))"
        let ivName = app.otherElements["ivName"].textFields.firstMatch
        ivName.tap()
        ivName.typeText(name)
        ivName.typeText("\n")
        sleep(1)
        app.otherElements["ivLocation"].textFields.firstMatch.tap()
        app.otherElements["ivLocation"].textFields.firstMatch.typeText("Prague")
        sleep(1)
        app.otherElements["ivDate"].textFields.firstMatch.tap()
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(Int.random(in: 0...12))")
        sleep(1)
        app.otherElements["ivDuration"].textFields.firstMatch.tap()
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "30")
        app.buttons["save_button"].tap()
        waitForLabel(name)
    }
    
    func testAddRemoteAktivity() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        app.buttons.firstMatch.tap()
        waitForLabel("title_label")
        let name = "Test Activity \(Int.random(in: 0...10))"
        let ivName = app.otherElements["ivName"].textFields.firstMatch
        ivName.tap()
        ivName.typeText(name)
        sleep(1)
        let ivLocation = app.otherElements["ivLocation"].textFields.firstMatch
        ivLocation.tap()
        ivLocation.typeText("Prague")
        sleep(1)
        app.otherElements["ivDate"].textFields.firstMatch.tap()
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "\(Int.random(in: 0...12))")
        sleep(1)
        app.otherElements["ivDuration"].textFields.firstMatch.tap()
        app.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "30")
        
        app.buttons["iCloud"].tap()
        app.buttons["save_button"].tap()
        
        waitForLabel(name)
    }
}

extension XCTestCase {

    var app: XCUIApplication { XCUIApplication() }

    func tapElementAndWaitForKeyboardToAppear(element: XCUIElement) {
        let keyboard = XCUIApplication().keyboards.element
        while (true) {
            element.tap()
            if keyboard.exists {
                break;
            }
            RunLoop.current.run(until: Date.init(timeIntervalSinceNow: 0.5))
        }
    }

    func waitForLabel(_ text: String, timeout: TimeInterval = 30) {
        let predicate = NSPredicate.init { (object, bindings) -> Bool in
            guard let app = object as? XCUIApplication else { return false }
            return app.staticTexts[text].exists
        }
        let expectEvents = expectation(for: predicate, evaluatedWith: app, handler: nil)
        expectEvents.expectationDescription = "WaitForLabel: \(text)"
        wait(for: [expectEvents], timeout: timeout)
    }

    func wait(for block: @autoclosure @escaping () -> Bool, timeout: TimeInterval = 30, description: String) {
        let predicate = NSPredicate.init(block: { (_, _) -> Bool in
            return block()
        })
        let exp = expectation(for: predicate, evaluatedWith: app, handler: nil)
        exp.expectationDescription = "BlockWaiting: \(description)"
        wait(for: [exp], timeout: timeout)
    }

}
