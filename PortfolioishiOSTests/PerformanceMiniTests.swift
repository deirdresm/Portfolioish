//
//  PerformanceMiniTests.swift
//  PortfolioishiOSTests
//
//  Created by Deirdre Saoirse Moen on 1/10/22.
//

import XCTest
import CoreData

@testable import Portfolioish

class PerformanceMiniTests: BaseTestCase {

	func testAwardCalculationPerformance() throws {
		// Create a significant amount of test data
		for _ in 1...100 {
			try persistence.createSampleData()
		}

		// Simulate lots of awards to check
		let awards = Array(repeating: Award.allAwards, count: 25).joined()

		measure {
			_ = awards.filter(persistence.hasEarned)
		}
	}
}
