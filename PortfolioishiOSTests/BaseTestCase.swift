//
//  PortfolioishiOSTests.swift
//  PortfolioishiOSTests
//
//  Created by Deirdre Saoirse Moen on 1/7/22.
//

import XCTest
import CoreData

@testable import Portfolioish

class BaseTestCase: XCTestCase {
	var persistence: Persistence!
	var moc: NSManagedObjectContext!

	override func setUpWithError() throws {
		persistence = Persistence(inMemory: true)
		moc = persistence.container.viewContext
	}
}
