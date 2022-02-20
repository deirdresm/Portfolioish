//
//  DevelopmentTests.swift
//  PortfolioishiOSTests
//
//  Created by Deirdre Saoirse Moen on 1/7/22.
//

import XCTest
import CoreData

@testable import Portfolioish

class DevelopmentTests: BaseTestCase {

	func testSampleDataCreationWorks() throws {
		try persistence.createSampleData()

		XCTAssertEqual(persistence.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
		XCTAssertEqual(persistence.count(for: Item.fetchRequest()), 50, "There should be 50 sample items.")
	}

	func testDeleteAllClearsEverything() throws {
		try persistence.createSampleData()
		persistence.deleteAll()

		XCTAssertEqual(persistence.count(for: Project.fetchRequest()), 0, "deleteAll() should leave 0 projects.")
		XCTAssertEqual(persistence.count(for: Item.fetchRequest()), 0, "deleteAll() should leave 0 items.")
	}
}
