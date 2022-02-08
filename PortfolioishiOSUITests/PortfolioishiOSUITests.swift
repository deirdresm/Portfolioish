//
//  PortfolioishiOSUITests.swift
//  PortfolioishiOSUITests
//
//  Created by Deirdre Saoirse Moen on 1/9/22.
//

import XCTest

class PortfolioishiOSUITests: XCTestCase {

	var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

		app = XCUIApplication()
		app.launchArguments.append("enable-testing")
		app.activate()
		sleep(1)
		print("app launched - \(app.launchArguments)")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
		XCTAssertEqual(app.tabBars.buttons.count, 5, "There should be 4 tabs in the app.")
	}

	func testOpenTabAddsProjects() {
		app.buttons["Reset"].tap()
		app.buttons["Open"].tap()
		XCTAssertEqual(app.tables.cells.count, 0, "There should be no initial project rows.")

		for tapCount in 1...5 {
			app.buttons["Add Project"].tap()
			XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) rows(s) in the list.")
		}
	}

	func testAddingItemInsertsRows() {
		app.buttons["Reset"].tap()
		app.buttons["Open"].tap()
		XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

		app.buttons["Add Project"].tap()
		XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

		app.buttons["Add New Item"].tap()
		XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an item.")
	}

	func testEditingProjectUpdatesCorrectly() {
		print("app launch arguments - \(app.launchArguments)")

		app.buttons["Reset"].tap()
		app.buttons["Open"].tap()
		XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

		app.buttons["Add Project"].tap()
		XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

//		app.buttons["New Project"].tap()
		app.buttons["Edit Project"].tap()
		app.textFields["Project name"].tap()

		app.keys["space"].tap()
		app.keys["more"].tap()
		app.keys["2"].tap()
		app.buttons["Return"].tap()

		app.buttons["Open Projects"].tap()

		XCTAssertTrue(app.buttons["NEW PROJECT 2"].exists, "The new project name should be visible in the list.")
	}

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
