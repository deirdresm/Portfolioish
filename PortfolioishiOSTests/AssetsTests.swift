//
//  AssetsTests.swift
//  PortfolioishiOSTests
//
//  Created by Deirdre Saoirse Moen on 1/7/22.
//

import XCTest

@testable import Portfolioish

class AssetsTests: XCTestCase {

	func testColorsPresent() {
		for color in Project.colors {
			XCTAssertNotNil(UIColor(named: color), "Failed to load color \(color) from asset catalog.")
		}
	}

	func testJSONloadsCorrectly() {
		XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON file.")
	}
}
