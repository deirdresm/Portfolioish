//
//  ProjectTests.swift
//  PortfolioishiOSTests
//
//  Created by Deirdre Saoirse Moen on 1/7/22.
//

import XCTest
import CoreData

@testable import Portfolioish

class ProjectTests: BaseTestCase {
	func testCreatingProjectsAndItems() {
		let targetCount = 0

		for _ in 0..<targetCount {
			let project = Project(context: moc)

			for _ in 0..<targetCount {
				let item = Item(context: moc)
				item.project = project
			}
		}

		XCTAssertEqual(persistence.count(for: Project.fetchRequest()), targetCount)
		XCTAssertEqual(persistence.count(for: Item.fetchRequest()), targetCount * targetCount)
	}

	func testDeletingProjectCascade() throws {
		try persistence.createSampleData()

		let request = NSFetchRequest<Project>(entityName: "Project")
		let projects = try moc.fetch(request)

		XCTAssertEqual(persistence.count(for: Project.fetchRequest()), 5)
		XCTAssertEqual(persistence.count(for: Item.fetchRequest()), 50)

		persistence.delete(projects[0])

		XCTAssertEqual(persistence.count(for: Project.fetchRequest()), 4)
		XCTAssertEqual(persistence.count(for: Item.fetchRequest()), 40)
	}
}
