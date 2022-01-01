//
//  Item+Extension.swift
//  Portfolioish
//
//  Created by Deirdre Saoirse Moen on 12/29/21.
//

import Foundation
import CoreData
import SwiftUI

extension Item {
	enum SortOrder {
		case optimized, title, createdOn
	}
	var itemTitle: String {
		title ?? "New Item"
	}

	var itemDetail: String {
		detail ?? ""
	}

	var itemCreatedOn: Date {
		createdOn ?? Date()
	}

	static var example: Item {
		let controller = PersistenceController(inMemory: true)
		let viewContext = controller.container.viewContext

		let item = Item(context: viewContext)
		item.title = "Example Item"
		item.detail = "This is an example item"
		item.priority = 3
		item.createdOn = Date()
		return item
	}}
