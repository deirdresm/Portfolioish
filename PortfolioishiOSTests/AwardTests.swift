//
//  AwardTests.swift
//  PortfolioishiOSTests
//
//  Created by Deirdre Saoirse Moen on 1/7/22.
//

import XCTest
import CoreData

@testable import Portfolioish

class AwardTests: BaseTestCase {
	let awards = Award.allAwards

	func testAwardIDMatchesName() {
		for award in awards {
			XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
		}
	}

	func testNoAwards() throws {
		for award in awards {
			XCTAssertFalse(persistence.hasEarned(award: award), "New users should have no earned awards")
		}
	}

	func testAddingItems() {
		let values = [1, 10, 20, 50, 100, 250, 500, 1000]

		for (count, value) in values.enumerated() {
			for _ in 0..<value {
				_ = Item(context: moc)
			}

			let matches = awards.filter { award in
				award.criterion == "items" && persistence.hasEarned(award: award)
			}

			XCTAssertEqual(matches.count, count + 1, "Adding \(value) items should unlock \(count + 1) awards.")

			persistence.deleteAll()
		}
	}

	func testCompletingItems() {
		let values = [1, 10, 20, 50, 100, 250, 500, 1000]

		for (count, value) in values.enumerated() {
			for _ in 0..<value {
				let item = Item(context: moc)
				item.completed = true
			}

			let matches = awards.filter { award in
				award.criterion == "complete" && persistence.hasEarned(award: award)
			}

			XCTAssertEqual(matches.count, count + 1, "Completing \(value) items should unlock \(count + 1) awards.")

			persistence.deleteAll()
		}
	}

	func testExampleProjectIsClosed() {
		let project = Project.example
		XCTAssertTrue(project.closed, "The example project should be closed.")
	}

	func testExampleItemIsHighPriority() {
		let item = Item.example
		XCTAssertEqual(item.priority, 3, "The example item should be high priority.")
	}
}
